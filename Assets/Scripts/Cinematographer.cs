using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class Cinematographer : MonoBehaviour {
    private Camera cam;

    [SerializeField] private List<Transform> targets;
    [SerializeField] private Vector3 offset;
    [SerializeField] private float smoothTime = .5f;
    private Vector3 velocity;

    [SerializeField] private float minPosX = -10f;
    [SerializeField] private float maxPosX = 40f;

    [SerializeField] private float minFov = 10f;
    [SerializeField] private float maxFov = 20f;
    [SerializeField] private float boundWidthWhenMaxFov = 30f;

    void Start() {
        cam = GetComponent<Camera>();
    }

    void LateUpdate() {
        Bounds? bound = CalcBounds();
        if (!bound.HasValue)
            return;
        Vector3 center = bound.Value.center;
        float width = bound.Value.size.x;

        Vector3 targetPos = center + offset;
        targetPos.x = Mathf.Clamp(targetPos.x, minPosX, maxPosX);
        targetPos.z = transform.position.z;
        transform.position = Vector3.SmoothDamp(transform.position, targetPos, ref velocity, smoothTime);

        float targetFov = Mathf.Lerp(minFov, maxFov, width / boundWidthWhenMaxFov);
        cam.fieldOfView = Mathf.Lerp(cam.fieldOfView, targetFov, Time.deltaTime);
    }

    Bounds? CalcBounds() {
        if (targets.Count == 0)
            return null;
        var bound = new Bounds(targets[0].position, Vector3.zero);
        foreach (var target in targets.Skip(1))
            bound.Encapsulate(target.position);
        return bound;
    }
}