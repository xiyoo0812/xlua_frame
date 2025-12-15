//XluaManager.cs

using System;
using UnityEngine;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using XLua;
using FairyGUI;

public static class XluaManager {
    private struct LogEntry {
        public uint level;
        public string message;
    }

    const string LUADLL = "xlua";
    private static LuaEnv s_Luaenv;
    private static string s_RootArg;
    private static IntPtr s_Quanta = IntPtr.Zero;
    private static readonly object s_QueueLock = new object();
    private static readonly Queue<LogEntry> s_LogQueue = new Queue<LogEntry>();

    [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
    public static extern IntPtr init_quanta(IntPtr L, int argc, string[] argv);
    public static IntPtr InitQuanta(IntPtr L, int argc, string[] argv) {
        return init_quanta(L, argc, argv);
    }

    [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
    public static extern void stop_quanta(IntPtr quanta);
    public static void StopQuanta(IntPtr quanta){
        stop_quanta(quanta);
    }

    [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
    public static extern bool run_quanta(IntPtr quanta);
    public static bool RunQuanta(IntPtr quanat) {
        return run_quanta(quanat);
    }

    [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
    public static extern IntPtr last_error();
    public static string GetLastError() {
        IntPtr errorPtr = last_error();
        string err = Marshal.PtrToStringAnsi(errorPtr);
        if (err == null) err = Marshal.PtrToStringUTF8(errorPtr);
        return err;
    }

    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    public delegate void UnityConsoleOutputDelegate(IntPtr msg, UIntPtr msglen, UIntPtr level);

    [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
    public static extern int lualog_set_logger(UnityConsoleOutputDelegate fn);
    public static void SetLuaLogger(UnityConsoleOutputDelegate fn) {
        lualog_set_logger(fn);
    }

    public static void Start() {
        s_Luaenv = new LuaEnv();
        SetLuaLogger(UnityConsoleOutput);
        string[] cmdline = System.Environment.GetCommandLineArgs();
        string[] argv = { cmdline[0], "Lua/xlua.conf", "", "" };
        if (cmdline.Length > 1) argv[2] = "--ROOT_ARGV=" + cmdline[1];
#if UNITY_EDITOR
        argv[2] = "--UNITY_DRITOR=1";
#endif
        IntPtr quanta = InitQuanta(s_Luaenv.L, argv.Length, argv);
        if (quanta == IntPtr.Zero) {
            string err = GetLastError();
            Debug.LogError($"InitQuanta Error: {err}");
        } else {
            s_Quanta = quanta;
            Debug.Log("InitQuanta Success!");
        }
    }

    public static void Update() {
        if (s_Quanta != IntPtr.Zero) {
            RunQuanta(s_Quanta);
        }
        ProcessLogQueue();
    }

    public static void OnDestroy() {
        if (s_Quanta != IntPtr.Zero) {
            ProcessLogQueue();
            StopQuanta(s_Quanta);
            s_Quanta = IntPtr.Zero;
        }
    }

    [MonoPInvokeCallback(typeof(UnityConsoleOutputDelegate))]
    public static void UnityConsoleOutput(IntPtr msgPtr, UIntPtr msglen, UIntPtr level) {
        int len = (int)msglen.ToUInt32();
        string message = Marshal.PtrToStringAnsi(msgPtr, len);
        if (message == null) message = Marshal.PtrToStringUTF8(msgPtr, len);
        if (message != null) {
            lock (s_QueueLock) {
                s_LogQueue.Enqueue(new LogEntry { message = message, level = level.ToUInt32() });
            }
        }
    }

    public static void ProcessLogQueue() {
        LogEntry[] logsToProcess = null;
        lock (s_QueueLock) {
            if (s_LogQueue.Count > 0) {
                logsToProcess = s_LogQueue.ToArray();
                s_LogQueue.Clear();
            }
        }
        if (logsToProcess != null) {
            foreach (var log in logsToProcess) {
                switch (log.level) {
                    case 5: Debug.LogError(log.message); break;
                    case 3: Debug.LogWarning(log.message); break;
                    case 6: Debug.LogException(new Exception(log.message)); break;
                    default: Debug.Log(log.message); break;
                }
            }
        }
    }
}
