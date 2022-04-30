using System;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;
using UnityEngine.UIElements;

public class HealthBarUI : MonoBehaviour {
    [SerializeField] private Character chr;
    [SerializeField] private bool isPlayer = false;
    [SerializeField] private string playerStatsId = "PlayerStatsL";

    private VisualElement container;

    private VisualElement healthBarVal;
    private float prevHealth;
    private float barDisplayHealth;

    void Start() {
        barDisplayHealth = prevHealth = 100f;

        var root = GetComponent<UIDocument>().rootVisualElement;
        container = root.Q<VisualElement>(playerStatsId);
        healthBarVal = container.Q<VisualElement>("HealthBarVal");
    }

    void Update() {
        float curHealth = chr.health;

        if (Math.Abs(curHealth - prevHealth) > .01f)
            ShakeVisualElement(container);

        // value.text = $"{curHealth:F1}<size=40%>%";
        barDisplayHealth = Mathf.Lerp(barDisplayHealth, curHealth, .1f);
        healthBarVal.style.width = Length.Percent(barDisplayHealth);

        prevHealth = curHealth;
    }

    private void ShakeVisualElement(VisualElement elm) {
        DOTween.Shake(
            () => new Vector3(
                elm.style.left.value.value,
                elm.style.top.value.value,
                0
            ),
            x => {
                elm.style.left = new Length(x.x);
                elm.style.top = new Length(x.y);
            },
            .5f, 20f, 30
        );
    }
}