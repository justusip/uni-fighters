using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Startup : MonoBehaviour {
    void Start() {
        StartCoroutine(RunLater());

        IEnumerator RunLater() {
            yield return null;
            SceneLoader.instance.Load("Main Menu");
        }
    }
}