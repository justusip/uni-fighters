using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

public class Silhouette : MonoBehaviour {
    private Animator anim;
    private float speed = .5f;
    [SerializeField] private float maxSpeed = 1f;
    [SerializeField] LayerMask groundLayerMask;
    private bool lastTimeRun = true;

    private float dir;

    void Start() {
        anim = GetComponent<Animator>();
        var gosh = Random.Range(0f, 1f);
        if (gosh < .5f)
            speed = Random.Range(0.5f, 0.6f);
        else if (gosh < .6f)
            speed = Random.Range(0.6f, 0.9f);
        else
            speed = Random.Range(0.9f, 1f);
        dir = Vector3.Dot(transform.forward, Vector3.right) >= 0 ? 1 : -1;
    }

    void Update() {
        transform.position += Vector3.right * dir * Time.deltaTime * speed * maxSpeed;
        anim.SetFloat("Speed", speed);

        RaycastHit hit;
        var pos = transform.position;
        if (Physics.Raycast(
                pos + (transform.up * 1f),
                Vector3.down,
                out hit,
                3f,
                groundLayerMask
            )) {
            pos.y = hit.point.y - .1f;
            transform.position = pos;
        } else {
            Destroy(gameObject);
        }
    }
}