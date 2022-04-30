using System.Collections;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using DG.Tweening;

public class SceneLoader : MonoBehaviour {
    public static SceneLoader instance;
    [SerializeField] private Canvas canvas;
    [SerializeField] private Image overlay;
    [SerializeField] private Image loadingWheel;

    private bool isLoadingScene = false;

    void Awake() {
        if (instance == null) {
            instance = this;
            DontDestroyOnLoad(gameObject);
        } else {
            Destroy(gameObject);
        }

        // Prevents 
        overlay.material = new Material(overlay.material);
    }

    void Start() {
        canvas.gameObject.SetActive(false);
        loadingWheel.gameObject.SetActive(false);
    }

    void Update() { }

    public void Load(string sceneName) {
        if (!isLoadingScene)
            StartCoroutine(LoadSceneRoutine(sceneName));
    }

    private IEnumerator LoadSceneRoutine(string sceneName) {
        isLoadingScene = true;

        Debug.Log(sceneName);
        foreach (var asrc in FindObjectsOfType<AudioSource>()) {
            DOTween.To(() => asrc.volume, x => asrc.volume = x, 0f, 1f).SetUpdate(true);
        }

        canvas.gameObject.SetActive(true);
        var mat = overlay.material;
        mat.DOFloat(1f, "_CutOff", 1f).SetUpdate(true);
        yield return new WaitForSecondsRealtime(1f);
        loadingWheel.gameObject.SetActive(true);
        loadingWheel.DOFade(1f, .5f).From(0f).SetUpdate(true);

        //bruh
        yield return new WaitForSecondsRealtime(.5f);

        var scene = SceneManager.LoadSceneAsync(sceneName);

        while (!scene.isDone)
            yield return null;
        yield return new WaitForEndOfFrame();

        Time.timeScale = 1;
        loadingWheel.DOFade(0f, .5f).From(1f).SetUpdate(true);
        yield return new WaitForSecondsRealtime(.5f);
        mat.DOFloat(0f, "_CutOff", 1f).SetUpdate(true);
        yield return new WaitForSecondsRealtime(1f);
        canvas.gameObject.SetActive(false);
        loadingWheel.gameObject.SetActive(false);

        isLoadingScene = false;
    }
}