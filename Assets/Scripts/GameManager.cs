using System;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.UIElements;

public class GameManager : MonoBehaviour {
    private SceneLoader sl;

    [SerializeField] private int roundTime = 60;
    private float? roundStartTime;

    [SerializeField] private bool countdown = true;

    private VisualElement root;
    private VisualElement body;
    private VisualElement gameOverOverlay;
    private VisualElement pauseMenu;
    private Label timeLeftLabel;
    private Label centerTextLbl;

    [SerializeField] private List<Character> characters;
    [SerializeField] private Character myself;

    private AudioSource asrc;
    [SerializeField] private AudioSource theme;
    [SerializeField] private AudioClip gameEndSound;

    public enum RoundStatus {
        COUNTDOWN,
        INGAME,
        PAUSED,
        END
    }

    private RoundStatus status;

    public RoundStatus Status => status;

    private enum GameOverReason {
        TIMEOUT,
        SOMEONE_DIDED
    }

    void Start() {
        asrc = GetComponent<AudioSource>();
        sl = SceneLoader.instance;

        root = FindObjectOfType<UIDocument>().rootVisualElement;
        body = root.Q<VisualElement>("Body");
        timeLeftLabel = root.Q<Label>("TimeLeft");
        centerTextLbl = root.Q<Label>("CenterText");
        gameOverOverlay = root.Q<VisualElement>("GameOverOverlay");
        pauseMenu = root.Q<VisualElement>("PauseMenu");

        pauseMenu.visible = false;
        gameOverOverlay.visible = false;

        root.Q<Button>("BtnRestart").RegisterCallback<ClickEvent>(e => {
            sl.Load("University Street");
        });
        root.Q<Button>("BtnMainMenu").RegisterCallback<ClickEvent>(e => {
            sl.Load("Main Menu");
        });
        root.Q<Button>("BtnRestart2").RegisterCallback<ClickEvent>(e => {
            sl.Load("University Street");
        });
        root.Q<Button>("BtnMainMenu2").RegisterCallback<ClickEvent>(e => {
            sl.Load("Main Menu");
        });

        body.style.opacity = 0f;

        StartCoroutine(Countdown());

        IEnumerator Countdown() {
            if (countdown) {
                status = RoundStatus.COUNTDOWN;

                centerTextLbl.visible = false;
                yield return new WaitForSeconds(2);
                centerTextLbl.visible = true;
                for (int i = 3; i >= 1; i--) {
                    centerTextLbl.text = i.ToString();
                    DOTween.To(
                        () => centerTextLbl.transform.scale,
                        o => centerTextLbl.transform.scale = o,
                        new Vector3(2, 2, 1),
                        1f
                    ).From(new Vector3(1, 1, 1));
                    DOTween.To(
                        () => centerTextLbl.style.opacity.value,
                        o => centerTextLbl.style.opacity = o,
                        0f,
                        .5f
                    ).From(1f).SetDelay(.5f);
                    yield return new WaitForSeconds(1);
                }
            }

            status = RoundStatus.INGAME;

            centerTextLbl.visible = false;
            roundStartTime = Time.time;

            DOTween.To(
                () => body.style.opacity.value,
                o => body.style.opacity = o,
                1f,
                1f
            ).From(0f);
        }
    }

    void Update() {
        switch (status) {
            case RoundStatus.INGAME:
                if (Keyboard.current.escapeKey.wasPressedThisFrame) {
                    status = RoundStatus.PAUSED;
                    Time.timeScale = 0f;
                    pauseMenu.visible = true;
                    return;
                }

                if (roundStartTime.HasValue) {
                    float timeElapsed = Time.time - roundStartTime.Value;
                    int secRemaining = (int) Math.Floor(roundTime - timeElapsed);
                    timeLeftLabel.text = secRemaining.ToString();
                    if (secRemaining == 0) {
                        roundStartTime = null;
                        StartCoroutine(GameOver(GameOverReason.TIMEOUT));
                    }
                }

                foreach (var chr in characters) {
                    if (chr.health <= 0f) {
                        StartCoroutine(GameOver(GameOverReason.SOMEONE_DIDED));
                    }
                }

                break;
            case RoundStatus.PAUSED:
                if (Keyboard.current.escapeKey.wasPressedThisFrame) {
                    pauseMenu.visible = false;
                    Time.timeScale = 1f;
                    status = RoundStatus.INGAME;
                    return;
                }

                break;
        }
    }

    private IEnumerator GameOver(GameOverReason r) {
        theme.Stop();
        asrc.clip = gameEndSound;
        asrc.Play();

        status = RoundStatus.END;
        yield return new WaitForSeconds(1f);
        centerTextLbl.visible = true;
        switch (r) {
            case GameOverReason.TIMEOUT:
                centerTextLbl.text = "Time Out!";
                break;
            case GameOverReason.SOMEONE_DIDED:
                if (myself.health <= 0)
                    centerTextLbl.text = "You died!";
                else
                    centerTextLbl.text = "You win!";
                break;
        }

        DOTween.To(
            () => centerTextLbl.transform.scale,
            o => centerTextLbl.transform.scale = o,
            new Vector3(1, 1, 1),
            1f
        ).From(new Vector3(.5f, .5f, 1));
        DOTween.To(
            () => centerTextLbl.style.opacity.value,
            o => centerTextLbl.style.opacity = o,
            1f,
            .5f
        ).From(0f).SetDelay(.5f);

        yield return new WaitForSeconds(3f);
        gameOverOverlay.visible = true;
        DOTween.To(() => gameOverOverlay.style.opacity.value, o => gameOverOverlay.style.opacity = o, 1f, 1f).From(0f);
        yield return new WaitForSeconds(1f);
    }
}