using System;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;
using UnityEngine.InputSystem;

public class Comic : MonoBehaviour {
    [SerializeField] private List<SpriteRenderer> pages;

    void Start() {
        StartCoroutine(Display());
    }

    void Update() {
        if (Keyboard.current.spaceKey.wasPressedThisFrame) {
            FindObjectOfType<SceneLoader>().Load("University Street");
        }
    }

    IEnumerator Display() {
        foreach (var page in pages) {
            page.gameObject.SetActive(true);
            page.color = new Color(1f, 1f, 1f, 0f);
        }

        yield return new WaitForSeconds(1f);

        for (int i = 0; i < pages.Count; i++) {
            if (i >= 1) {
                pages[i - 1].DOColor(Color.clear, .5f).From(Color.white);
            }

            var page = pages[i];
            page.transform.DOMove(Vector3.zero, 1f).From(Vector3.right * -3f).SetEase(Ease.OutCubic);
            page.transform.DOScale(page.transform.localScale * 1.1f, 4f);
            page.DOColor(Color.white, 1f).From(new Color(1f, 1f, 1f, 0f));
            yield return new WaitForSeconds(4);
        }

        FindObjectOfType<SceneLoader>().Load("University Street");
    }
}