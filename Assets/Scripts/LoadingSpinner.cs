using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LoadingSpinner : MonoBehaviour {
    void Start() { }

    void Update() {
        var eulerAngles = transform.eulerAngles;
        transform.rotation = Quaternion.Euler(eulerAngles.x, eulerAngles.y, -Time.realtimeSinceStartup * 360f);
    }
}