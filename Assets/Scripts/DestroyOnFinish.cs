using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DestroyOnFinish : MonoBehaviour {
    [SerializeField] private float duration = 2;

    void Start() {
        Destroy(gameObject, duration);
    }
}