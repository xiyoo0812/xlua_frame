//XluaManager.cs

using System;
using System.IO;
using UnityEngine;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using XLua;
using System.Text;

public static class XluaManager {
    private struct LogEntry {
        public uint level;
        public string message;
    }

    const string LUADLL = "xlua";
    private static LuaEnv s_Luaenv;
    private static readonly object s_QueueLock = new object();
    private static readonly Queue<LogEntry> s_LogQueue = new Queue<LogEntry>();

    [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
    public static extern string init_quanta(IntPtr L, string conf);
    [MonoPInvokeCallback(typeof(XLua.LuaDLL.lua_CSFunction))]
    public static string InitQuanta(IntPtr L, string conf) {
        return init_quanta(L, conf);
    }

    [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
    public static extern bool run_quanta(IntPtr L);
    [MonoPInvokeCallback(typeof(XLua.LuaDLL.lua_CSFunction))]
    public static bool RunQuanta(IntPtr L) {
        return run_quanta(L);
    }

    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    public delegate void UnityConsoleOutputDelegate(IntPtr msg, UIntPtr msglen, UIntPtr level);

    [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
    public static extern int lualog_set_logger(UnityConsoleOutputDelegate fn);
    [MonoPInvokeCallback(typeof(XLua.LuaDLL.lua_CSFunction))]
    public static void SetLuaLogger(UnityConsoleOutputDelegate fn) {
        lualog_set_logger(fn);
    }

    public static void Start() {
        s_Luaenv = new LuaEnv();
        SetLuaLogger(UnityConsoleOutput);
        string res = InitQuanta(s_Luaenv.L, "Lua/xlua.conf");
        Debug.LogFormat($"InitQuanta: {res}");
    }

    public static void Update() {
    //    RunQuanta(s_Luaenv.L);
    }

    [MonoPInvokeCallback(typeof(UnityConsoleOutputDelegate))]
    public static void UnityConsoleOutput(IntPtr msgPtr, UIntPtr msglen, UIntPtr level) {
        try {
            int len = (int)msglen.ToUInt32();
            string message = Marshal.PtrToStringAnsi(msgPtr, len);
            if (message == null) {
                byte[] buffer = new byte[len];
                Marshal.Copy(msgPtr, buffer, 0, len);
                message = Encoding.UTF8.GetString(buffer);
            }
            if (message == null) throw new Exception();
            lock (s_QueueLock) {
                s_LogQueue.Enqueue(new LogEntry { message = message, level = level.ToUInt32() });
            }
        } catch (Exception e) {
            Debug.LogError($"[UnityLogBridge] Error processing log message: {e.Message}");
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
                    case 4: Debug.LogError(log.message); break;
                    case 2: Debug.LogWarning(log.message); break;
                    case 5: Debug.LogException(new Exception(log.message)); break;
                    default: Debug.Log(log.message); break;
                }
            }
        }
    }
}
