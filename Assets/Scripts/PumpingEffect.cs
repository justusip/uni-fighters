using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PumpingEffect : MonoBehaviour {
    void Start() { }

    void Update() {
        transform.localScale = new Vector3(1, 1, 1) * (Mathf.Sin(Time.time * 4f) * .2f + 1.2f);
    }
}