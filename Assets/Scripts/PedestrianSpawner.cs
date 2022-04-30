using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PedestrianSpawner : MonoBehaviour {
    [SerializeField] private float freqA;
    [SerializeField] private float freqB;
    private float spawnNextAt;

    [SerializeField] private Transform pref;

    public void Start() {
        Spawn();
    }

    public void Update() {
        if (Time.time > spawnNextAt) {
            Spawn();
        }
    }

    private void Spawn() {
        spawnNextAt = Time.time + Random.Range(freqA, freqB);
        Instantiate(pref, transform.position, transform.rotation);
    }
}