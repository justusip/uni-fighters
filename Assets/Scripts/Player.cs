using UnityEngine;
using UnityEngine.InputSystem;

public class Player : MonoBehaviour {
    private GameManager gm;
    private Character chr;
    private PlayerInput input;

    void Start() {
        gm = FindObjectOfType<GameManager>();
        chr = GetComponent<Character>();
        input = GetComponent<PlayerInput>();
    }

    void Update() {
        if (gm.Status != GameManager.RoundStatus.INGAME) {
            chr.moveInput = Vector2.zero;
            chr.desiringBlock = false;
            return;
        }
        
        chr.moveInput = input.actions["Move"].ReadValue<Vector2>();
        chr.desiredJump |= input.actions["Jump"].WasPressedThisFrame();
        if (Keyboard.current.jKey.wasPressedThisFrame)
            chr.desiredPunch = true;
        if (Keyboard.current.kKey.wasPressedThisFrame)
            chr.desiredKick = true;
        chr.desiringBlock = Keyboard.current.lKey.isPressed;

    }
}