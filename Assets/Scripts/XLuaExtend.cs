//XLuaExtend.cs

namespace XLua.LuaDLL {

    using System.Runtime.InteropServices;

    public partial class Lua {
        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern int luaopen_luapb(System.IntPtr L);
        [MonoPInvokeCallback(typeof(LuaDLL.lua_CSFunction))]
        public static int LoadLuaPb(System.IntPtr L) {
            return luaopen_luapb(L);
        }

        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern int luaopen_ljson(System.IntPtr L);
        [MonoPInvokeCallback(typeof(LuaDLL.lua_CSFunction))]
        public static int LoadLuaJson(System.IntPtr L) {
            return luaopen_ljson(L);
        }

        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern int luaopen_luabus(System.IntPtr L);
        [MonoPInvokeCallback(typeof(LuaDLL.lua_CSFunction))]
        public static int LoadLuaBus(System.IntPtr L) {
            return luaopen_luabus(L);
        }
    }
}
