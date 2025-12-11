//Global.cs

using FairyGUI;
using UnityEngine;
using System.IO;
using System.Reflection;

public class Global : MonoBehaviour {
    // Use this for initialization
    void Start () {
        string[] args = System.Environment.GetCommandLineArgs();
        if (args.Length >= 2) {
            XluaManager.Init(args[1]);
        }
        XluaManager.Start();
    }

    // Use this for initialization
    void Awake () {
        Application.runInBackground = true;
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