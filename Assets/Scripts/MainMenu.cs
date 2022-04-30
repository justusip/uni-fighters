using System;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.UIElements;

public class MainMenu : MonoBehaviour {
    [SerializeField] private float angleOffset;
    private float originalAngle;
    private int selBtnIdx = 0;

    private List<Transform> sels = new();

    [SerializeField] private List<Color> focusColours;
    [SerializeField] private Color blurColour = Color.gray;

    private AudioSource asrc;
    [SerializeField] private AudioClip selSound;
    [SerializeField] private AudioClip loadSound;

    private VisualElement root;
    private bool settingsDisplayed = false;
    private VisualElement settingsOverlay;

    void Start() {
        asrc = GetComponent<AudioSource>();
        root = FindObjectOfType<UIDocument>().rootVisualElement;
        settingsOverlay = root.Q("SettingsOverlay");
        settingsOverlay.visible = false;
        root.Q("BtnDifficulty").SetEnabled(false);
        root.Q<Button>("BtnCancel").clicked += () => {
            SetSettingsPopupEnabled(false);
        };
        root.Q<Button>("BtnConfirm").clicked += () => {
            SetSettingsPopupEnabled(false);
        };

        foreach (Transform c in transform) {
            sels.Add(c);
            c.GetComponent<Renderer>().material = new Material(c.GetComponent<Renderer>().material);
            c.localScale = new Vector3(1, 0, 1);

            IEnumerator RunLater() {
                yield return new WaitForSeconds(1 + sels.Count * .2f);
                c.DOScale(new Vector3(1, 1, 1), 1f).From(new Vector3(1, 0, 1)).SetEase(Ease.OutElastic);
            }

            StartCoroutine(RunLater());
        }
    }

    void Update() {
        if (settingsDisplayed)
            return;
        int idxOffset = 0;
        if (Keyboard.current.downArrowKey.wasPressedThisFrame)
            idxOffset += 1;
        if (Keyboard.current.upArrowKey.wasPressedThisFrame)
            idxOffset -= 1;
        selBtnIdx = Math.Clamp(selBtnIdx + idxOffset, 0, 2);

        if (idxOffset != 0) {
            asrc.clip = selSound;
            asrc.Play();
        }

        float targetAngle = originalAngle + angleOffset * selBtnIdx;
        var rot = transform.eulerAngles;
        rot.z = Mathf.LerpAngle(rot.z, targetAngle, .2f);
        transform.eulerAngles = rot;

        for (int i = 0; i < sels.Count; i++) {
            var thisSelected = selBtnIdx == i;
            var mat = sels[i].GetComponent<Renderer>().material;
            mat.color = thisSelected ? focusColours[selBtnIdx] : blurColour;
        }

        GetComponent<Renderer>().material.color = focusColours[selBtnIdx];

        if (Keyboard.current.enterKey.wasPressedThisFrame) {
            asrc.clip = loadSound;
            asrc.Play();
            switch (selBtnIdx) {
                case 0:
                    FindObjectOfType<SceneLoader>().Load("Comic");
                    break;
                case 1:
                    SetSettingsPopupEnabled(true);
                    break;
                case 2:
                    Application.Quit();
                    break;
            }
        }
    }

    private void SetSettingsPopupEnabled(bool enabled) {
        settingsOverlay.visible = enabled;
        settingsDisplayed = enabled;
        if (enabled) {
            DOTween.ToAlpha(
                () => settingsOverlay.style.backgroundColor.value,
                o => settingsOverlay.style.backgroundColor = o,
                .8f,
                1f
            ).From(0f);
        }
    }
}