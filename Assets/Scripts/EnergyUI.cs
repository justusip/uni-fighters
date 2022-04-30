using System;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;
using UnityEngine.UIElements;

public class EnergyUI : MonoBehaviour {
    [SerializeField] private List<Sprite> punchIcons;
    [SerializeField] private Character chr;

    private VisualElement energyBar;
    private List<VisualElement> energies;
    private int prevEnergyLeft;

    void Start() {
        var root = GetComponent<UIDocument>().rootVisualElement;
        energyBar = root.Q<VisualElement>("EnergyBar");
        energies = root.Query<VisualElement>(className: "Energy").ToList();
    }

    void Update() { }

    public void SetEnergyLeft(int energyLeft) {
        int punchesLeft = chr.energyLeft;
        for (int i = 0; i < energies.Count; i++) {
            int quotient = punchesLeft / 4;
            int remainder = punchesLeft % 4;
            VisualElement punch = energies[i];

            Sprite icon;
            if (i == quotient)
                icon = punchIcons[remainder];
            else if (i < quotient)
                icon = punchIcons[4];
            else
                icon = punchIcons[0];

            if ((energyLeft < prevEnergyLeft && quotient == i) || (energyLeft > prevEnergyLeft && quotient == i + 1))
                DOTween.To(
                        () => punch.transform.scale,
                        o => punch.transform.scale = o,
                        new Vector3(1f, 1f, 1),
                        .2f
                    ).SetEase(Ease.Linear)
                    .From(new Vector3(2f, 2f, 1f));

            punch.style.backgroundImage = new StyleBackground(icon);
        }

        prevEnergyLeft = energyLeft;
    }

    public void RemindNoEnergy() {
        foreach (var icon in energies)
            DOTween.To(
                () => icon.style.unityBackgroundImageTintColor.value,
                o => icon.style.unityBackgroundImageTintColor = o,
                Color.white,
                .2f
            ).SetEase(Ease.Linear).From(Color.red);
        DOTween.To(
            () => energyBar.transform.scale,
            o => energyBar.transform.scale = o,
            new Vector3(1f, 1f, 1f),
            .2f
        ).SetEase(Ease.Linear).From(new Vector3(1.5f, 1.5f, 1));
    }
}