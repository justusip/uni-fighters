using System.Collections;
using UnityEngine;
using Random = UnityEngine.Random;
using Vector2 = UnityEngine.Vector2;
using Vector3 = UnityEngine.Vector3;

public class Enemy : MonoBehaviour {
    [SerializeField] private GameObject player;

    private GameManager gm;
    private Character chr;

    private Vector3? targetPos = null;

    private Coroutine activeRoutine;

    void Start() {
        gm = FindObjectOfType<GameManager>();
        chr = GetComponent<Character>();

        StartCoroutine(Routine());
    }

    void Update() {
        if (gm.Status != GameManager.RoundStatus.INGAME) {
            chr.moveInput = Vector2.zero;
            chr.desiringBlock = false;
            return;
        }

        if (targetPos.HasValue) {
            var vecToTarget = targetPos.Value - transform.position;
            var dirToTarget = vecToTarget.normalized;
            var disToTarget = vecToTarget.magnitude;
            var onRight = dirToTarget.x > 0;
            var velToTarget = onRight ? 1f : -1f;
            chr.moveInput = velToTarget * Vector2.right;
        } else {
            chr.moveInput = Vector2.zero;
        }
    }

    private IEnumerator Routine() {
        bool gonnaPunch = false;
        while (true) {
            yield return StartCoroutine(WalkToPlayer(gonnaPunch ? .9f : 1.4f));
            yield return StartCoroutine(FacePlayer());
            yield return new WaitForSeconds(Random.Range(0.05f, 0.1f));
            RaycastHit hit;
            if (gm.Status == GameManager.RoundStatus.INGAME &&
                Physics.Raycast(
                    transform.position + (transform.up * .7f),
                    transform.forward,
                    out hit,
                    gonnaPunch ? 1f : 1.5f
                ) && hit.collider.gameObject == player) {
                if (gonnaPunch) chr.desiredPunch = true;
                else chr.desiredKick = true;

                gonnaPunch = !gonnaPunch;
                
                yield return new WaitForSeconds(Random.Range(0.1f, 0.3f));

                IEnumerator RetreatAndFacePlayer() {
                    var vecToTarget = player.transform.position - transform.position;
                    var onRight = vecToTarget.x > 0;
                    yield return StartCoroutine(WalkTo(
                        transform.position + Vector3.right * 4f * (onRight ? -1 : 1f),
                        1f
                    ));
                    yield return StartCoroutine(FacePlayer());
                }

                var c = StartCoroutine(RetreatAndFacePlayer());
                yield return new WaitForSeconds(Random.Range(.8f, 1.2f));
                StopCoroutine(c);
            }
        }
    }

    private IEnumerator WalkToPlayer(float untilDistance) {
        while (true) {
            targetPos = player.transform.position;
            if (Mathf.Abs(transform.position.x - targetPos.Value.x) <= untilDistance)
                break;
            yield return null;
        }

        targetPos = null;
    }

    private IEnumerator WalkTo(Vector3 pos, float untilDistance) {
        targetPos = pos;
        while (true) {
            if (Mathf.Abs(transform.position.x - targetPos.Value.x) <= untilDistance)
                break;
            yield return null;
        }

        targetPos = null;
    }

    private IEnumerator FacePlayer() {
        var vecToTarget = player.transform.position - transform.position;
        var onRight = vecToTarget.x > 0;
        chr.moveInput = Vector3.right * (onRight ? 1 : -1);
        yield return null;
    }

    private void OnDrawGizmos() {
        Gizmos.color = Color.red;
        Gizmos.DrawRay(transform.position + (transform.up * .7f), transform.forward);
    }
}