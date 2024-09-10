//XluaManager.cs

using System.IO;
using UnityEngine;
using XLua;

public static class XluaManager {
    private static LuaEnv _luaenv;

    public static LuaEnv Lua {
        get {
            if (_luaenv == null) {
                _luaenv = new LuaEnv();
                _luaenv.AddBuildin("luapb", XLua.LuaDLL.Lua.LoadLuaPb);
                _luaenv.AddBuildin("ljson", XLua.LuaDLL.Lua.LoadLuaJson);
                _luaenv.AddBuildin("luabus", XLua.LuaDLL.Lua.LoadLuaBus);
                _luaenv.AddLoader(luaLoader);
                //执行启动脚本
                _luaenv.DoString("require 'main'");
            }
            return _luaenv;
        }
    }

    private static byte[] luaLoader(ref string filename) {
        filename = filename.Replace('.', '/');
        string path = Application.dataPath + "/Resources/Lua/" + filename + ".lua";
        if(File.Exists(path)) {
            byte[] content = File.ReadAllBytes(path);
            return content;
        }
        return null;
    }
}
