//Global.cs

using UnityEngine;

public class Global : MonoBehaviour {

    // Use this for initialization
    void Start () {
        XluaManager.Start();
    }

    // Use this for initialization
    void Awake () {
         DontDestroyOnLoad(gameObject); // 标记对象跨场景不销毁
    }

    // Update is called once per frame
    void Update () {
        XluaManager.Update();
    }

    void OnDestroy() {
        XluaManager.OnDestroy();
    }
}