
using UnityEngine;
using UnityEngine.Events;
using System.Collections;
using System.Collections.Generic;

public static class ABMgr {
    private static AssetBundle mainAB = null;
    private static AssetBundleManifest manifest = null;

    private static Dictionary<string, AssetBundle> abDic = new Dictionary<string, AssetBundle>();

    private static string PathUrl {
        get {
            return Application.streamingAssetsPath + "/";
        }
    }

    private static string MainABName {
        get {
#if UNITY_IOS
            return "IOS";
#elif UNITY_ANDROID
            return "Android";
#else
            return "PC";
#endif
        }
    }

    public static AssetBundle LoadAB(string name) {
        if (mainAB == null) {
            mainAB = AssetBundle.LoadFromFile(PathUrl + MainABName);
            manifest = mainAB.LoadAsset<AssetBundleManifest>("AssetBundleManifest");
        }
        AssetBundle ab;
        string[] strs = manifest.GetAllDependencies(name);
        for (int i = 0; i < strs.Length; i++) {
            if (!abDic.ContainsKey(strs[i])) {
                ab = AssetBundle.LoadFromFile(PathUrl + strs[i]);
                abDic.Add(strs[i], ab);
            }
        }
        if (!abDic.ContainsKey(name)) {
            ab = AssetBundle.LoadFromFile(PathUrl + name);
            abDic.Add(name, ab);
        }
        return abDic[name];
    }

    public static Object LoadRes(string abName, string resName) {
        AssetBundle ab = LoadAB(abName);
        return ab.LoadAsset(resName);
    }

    public static Object LoadRes(string abName, string resName, System.Type type) {
        AssetBundle ab = LoadAB(abName);
        return ab.LoadAsset(resName, type);
    }

    public static Object LoadRes<T>(string abName, string resName) where T : Object {
        AssetBundle ab = LoadAB(abName);
        return ab.LoadAsset<T>(resName);
    }

    //public static void LoadResAnsync(string abName, string resName, UnityAction<Object> callback) {
    //    StartCoroutine(ReallyLoadResAsync(abName, resName, callback));
    //}

    //private static IEnumerator ReallyLoadResAsync(string abName, string resName, UnityAction<Object> callback) {
    //    AssetBundle ab = LoadAB(abName);
    //    AssetBundleRequest abr = ab.LoadAssetAsync(resName);
    //    yield return abr;
    //    callback(abr.asset);
    //}

    //public static void LoadResAnsync(string abName, string resName, System.Type type, UnityAction<Object> callback) {
    //    StartCoroutine(ReallyLoadResAsync(abName, resName, type, callback));
    //}

    //private static IEnumerator ReallyLoadResAsync(string abName, string resName, System.Type type, UnityAction<Object> callback) {
    //    LoadAB(abName);
    //    AssetBundleRequest abr = abDic[abName].LoadAssetAsync(resName, type);
    //    yield return abr;
    //    callback(abr.asset);
    //}

    //public static void LoadResAnsync<T>(string abName, string resName, UnityAction<Object> callback) where T : Object {
    //    StartCoroutine(ReallyLoadResAsync<T>(abName, resName, callback));
    //}

    //private static IEnumerator ReallyLoadResAsync<T>(string abName, string resName, UnityAction<Object> callback) where T : Object {
    //    LoadAB(abName);
    //    AssetBundleRequest abr = abDic[abName].LoadAssetAsync<T>(resName);
    //    yield return abr;
    //    callback(abr.asset as T);
    //}

    public static void UnLoad(string abName) {
        if (abDic.ContainsKey(abName)) {
            abDic[abName].Unload(false);
            abDic.Remove(abName);
        }
    }
    public static void ClearAB(string abName) {
        AssetBundle.UnloadAllAssetBundles(false);
        abDic.Clear();
        mainAB = null;
        manifest = null;
    }
}