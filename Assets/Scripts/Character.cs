using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.VFX;
using Color = UnityEngine.Color;
using Quaternion = UnityEngine.Quaternion;
using Random = UnityEngine.Random;
using Vector2 = UnityEngine.Vector2;
using Vector3 = UnityEngine.Vector3;

public class Character : MonoBehaviour {
    private GameManager gm;

    private Rigidbody rigi;
    private Animator anim;

    [SerializeField] float baseSpeed = 8;

    [SerializeField] LayerMask groundLayerMask;

    [SerializeField] float rotationSpeed = 0.1f;

    [SerializeField] public bool canMove = true;
    [SerializeField] private bool isGrounded;
    public bool isBlocking;
    private float? consumeEnergyForBlockingAt = null;

    public Vector2 moveInput;
    public bool desiredJump;
    public bool desiredPunch;
    public bool desiredKick;
    public bool desiringBlock;

    public float health = 100;
    private float direction;

    [SerializeField] private VisualEffect smoke;
    [SerializeField] private VisualEffect landingDust;
    [SerializeField] private VisualEffect impactEffect;

    [SerializeField] private float acceleration = 1.1f;
    [SerializeField] private float deceleration = .9f;
    [SerializeField] private float velPower = .9f;
    [SerializeField] private float friction = .9f;
    [SerializeField] private float jmpForce = .9f;
    [SerializeField] private float gravityIncrease = 2;

    [SerializeField] private int maxPunches = 20;
    public int energyLeft;
    [SerializeField] private float? addEnergyAt = null;
    [SerializeField] private float restoreSingleEnergySec = 2f;
    [SerializeField] private float revivePunchSec = 4f;

    private AudioSource asrc;
    [SerializeField] private List<AudioClip> clips;
    [SerializeField] private AudioClip swing;
    [SerializeField] private AudioClip invalidClick;

    void Start() {
        gm = FindObjectOfType<GameManager>();
        rigi = GetComponent<Rigidbody>();
        anim = GetComponent<Animator>();
        asrc = GetComponent<AudioSource>();

        energyLeft = maxPunches;
        direction = Vector3.Dot(transform.forward, Vector3.right) >= 0 ? 1 : -1;
    }

    void Update() {
        bool wasGrounded = isGrounded;
        isGrounded = CheckIsGrounded();
        anim.SetBool("isGrounded", isGrounded);
        if (!wasGrounded && isGrounded)
            Instantiate(landingDust.gameObject, transform.position, Quaternion.identity);

        if (isBlocking != desiringBlock) {
            if (desiringBlock) AttemptsEnterBlock();
            else ExitBlock();
        }

        if (!isGrounded)
            ExitBlock();

        if (consumeEnergyForBlockingAt.HasValue && Time.time > consumeEnergyForBlockingAt)
            ConsumeEnergyForBlock();

        anim.SetBool("IsBlocking", isBlocking);

        if (desiredPunch) {
            desiredPunch = false;
            AttemptPunch();
        }

        if (desiredKick) {
            desiredKick = false;
            AttemptKick();
        }

        if (gm.Status == GameManager.RoundStatus.INGAME && !isBlocking && addEnergyAt.HasValue &&
            Time.time > addEnergyAt) {
            addEnergyAt = null;
            energyLeft = Math.Min(energyLeft + 4, maxPunches);
            FindObjectOfType<EnergyUI>().SetEnergyLeft(energyLeft);
            if (energyLeft < maxPunches) {
                addEnergyAt = Time.time + restoreSingleEnergySec;
            } else {
                addEnergyAt = null;
            }
        }
    }

    private void FixedUpdate() {
        // Artificial Additional Gravity so the player will fall faster
        rigi.AddForce(Vector3.down * rigi.mass * gravityIncrease);

        float inputX = Mathf.Clamp(moveInput.x, -1f, 1f);
        if (canMove && !isBlocking && Mathf.Abs(inputX) > 0.03f)
            direction = moveInput.x > 0 ? 1 : -1;

        float targetSpeed = canMove && !isBlocking ? inputX * baseSpeed : 0f;
        float speedDiff = targetSpeed - rigi.velocity.x;
        float accelRate = (Mathf.Abs(targetSpeed) > 0.01f) ? acceleration : 0;
        float movement = Mathf.Pow(Mathf.Abs(speedDiff) * accelRate, velPower) * Mathf.Sign(speedDiff) * rigi.mass;
        rigi.AddForce(movement * Vector3.right);

        // Artificial Friction
        if (isGrounded && Mathf.Abs(moveInput.x) < 0.01f) {
            // If the player is in contact with the ground and not decided to walk
            rigi.AddForce(Vector2.right * friction * -rigi.velocity.x, ForceMode.Impulse);
        }

        if (desiredJump) {
            desiredJump = false;
            if (canMove && isGrounded) {
                rigi.AddForce(Vector3.up * jmpForce * rigi.mass, ForceMode.Impulse);
                anim.SetTrigger("Jump");
            }
        }

        anim.SetFloat("InputMagnitude", canMove ? Mathf.Abs(inputX) : 0f, .02f, Time.deltaTime);

        transform.rotation = Quaternion.Slerp(
            transform.rotation,
            Quaternion.LookRotation(Vector3.right * direction),
            rotationSpeed * Time.timeScale
        );
    }

    private bool AttemptsEnterBlock() {
        if (isBlocking)
            return true;
        if (!CanConsumeEnergy(1) || !canMove || !isGrounded)
            return false;
        ConsumeEnergyBy(1);
        isBlocking = true;
        consumeEnergyForBlockingAt = Time.time + .5f;
        return true;
    }

    private void ConsumeEnergyForBlock() {
        if (!isBlocking)
            return;
        if (!CanConsumeEnergy(1)) {
            ExitBlock();
            return;
        }

        ConsumeEnergyBy(1);
        consumeEnergyForBlockingAt = Time.time + .5f;
    }

    private void ExitBlock() {
        if (!isBlocking)
            return;
        isBlocking = false;
        consumeEnergyForBlockingAt = null;
    }

    private bool AttemptPunch() {
        if (!canMove)
            return false;
        if (IsPlayer()) {
            if (!CanConsumeEnergy(4))
                return false;
            ConsumeEnergyBy(4);
        }

        anim.SetTrigger("Punch");
        RaycastHit hit;
        if (Physics.Raycast(transform.position + (transform.up * .7f), transform.forward, out hit, 1f)) {
            asrc.clip = clips[Random.Range(0, clips.Count)];
            asrc.Play();
            if (GameObjectIsEnemy(hit.collider.gameObject))
                hit.collider.GetComponent<Character>().OnKnockback(
                    transform.position,
                    hit.point,
                    new Vector3(12f, 4f, 0),
                    Random.Range(4, 8)
                );
        } else {
            asrc.clip = swing;
            asrc.Play();
        }

        return true;
    }

    private bool AttemptKick() {
        if (!canMove)
            return false;
        if (IsPlayer()) {
            if (!CanConsumeEnergy(8))
                return false;
            ConsumeEnergyBy(8);
        }

        anim.SetTrigger("Kick");

        RaycastHit hit;
        if (Physics.Raycast(transform.position + (transform.up * .7f), transform.forward, out hit, 1.6f)) {
            asrc.clip = clips[Random.Range(0, clips.Count)];
            asrc.Play();
            if (GameObjectIsEnemy(hit.collider.gameObject))
                hit.collider.GetComponent<Character>().OnKnockback(
                    transform.position,
                    hit.point,
                    new Vector3(8f, 12f, 0f),
                    Random.Range(6, 14)
                );
        } else {
            asrc.clip = swing;
            asrc.Play();
        }

        return true;
    }

    public void OnKnockback(Vector3 from, Vector3 hitPos, Vector3 knockBack, float damage) {
        Instantiate(impactEffect.gameObject, hitPos, Quaternion.identity);
        
        var vecToMe = transform.position - from;
        var vecToMeNorm = vecToMe.normalized;
        var fromRight = vecToMe.x < 0;
        bool facesForce = Vector3.Dot(vecToMeNorm, Vector3.right * direction) < 0;

        if (isBlocking && facesForce)
            return;

        bool wasAlive = health > 0;
        health = Mathf.Max(health - damage, 0f);

        Vector3 impact = new Vector3((fromRight ? -1 : 1) * knockBack.x, knockBack.y, 0);
        rigi.AddForce(impact * rigi.mass, ForceMode.Impulse);

        if (wasAlive && health <= 0) {
            anim.SetTrigger("Dead");
        } else {
            anim.SetFloat("KnockOverDir", facesForce ? -1 : 1);
            anim.SetTrigger("KnockOver");
        }

        smoke.Play();
        StopCoroutine(nameof(EOnKnockback));
        StartCoroutine(nameof(EOnKnockback));
    }

    IEnumerator EOnKnockback() {
        canMove = false;
        yield return new WaitForSeconds(1f);
        smoke.Stop();
        yield return new WaitForSeconds(.5f);
        canMove = true;
    }

    private bool CanConsumeEnergy(int number) {
        bool canConsume = energyLeft >= number;
        if (!canConsume) {
            asrc.clip = invalidClick;
            asrc.Play();
            FindObjectOfType<EnergyUI>().RemindNoEnergy();
        }

        return canConsume;
    }

    private void ConsumeEnergyBy(int number) {
        if (energyLeft - number < 0)
            return;

        energyLeft -= number;
        FindObjectOfType<EnergyUI>().SetEnergyLeft(energyLeft);
        if (energyLeft == 0) {
            addEnergyAt = Time.time + revivePunchSec;
        } else {
            addEnergyAt = Time.time + restoreSingleEnergySec;
        }
    }

    bool CheckIsGrounded() {
        return Physics.Raycast(
            transform.position + (transform.up * .05f),
            Vector3.down,
            .1f,
            groundLayerMask
        );
    }

    private void OnDrawGizmos() {
        Gizmos.color = isGrounded ? Color.green : Color.red;
        Gizmos.DrawRay(transform.position + (transform.up * .05f), Vector3.down * .08f);
        Gizmos.color = Color.blue;
        Gizmos.DrawRay(transform.position + (transform.up * .05f), Vector3.down * .08f);
    }

    private bool IsPlayer() {
        return GetComponent<Player>() != null;
    }

    private bool GameObjectIsEnemy(GameObject go) {
        return go.GetComponent<Character>() != null && gameObject != go;
    }
}