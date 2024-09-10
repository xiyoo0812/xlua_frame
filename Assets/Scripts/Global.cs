//Global.cs

using UnityEngine;

public class Global : MonoBehaviour {

    // Use this for initialization
    void Start () {
    }

    // Use this for initialization
    void Awake () {
    }

    // Update is called once per frame
    void Update () {
        XluaManager.Lua.DoString("Update()");
    }

    void OnDestroy() {
    }
}