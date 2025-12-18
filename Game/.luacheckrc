self=false
stds.quanta = {
    globals = {
        "CS",
        --common
        "qtable", "qstring", "qmath", "ncmd_cs",
        "quanta", "environ", "signal", "service", "logger", "logfeature",
        "import", "class", "enum", "mixin", "property", "singleton", "super",
        "implemented", "storage", "classof", "is_class", "conv_class", "class_review",
        "codec", "stdfs", "luabus", "luakit", "json", "protobuf", "timer", "aoi", "log", "worker", 
        "http", "bson", "detour", "ssl", "xml", "zip", "yaml", "toml", "kcp", "csv", "xlsx", "profile"
    }
}
std = "max+quanta"
max_cyclomatic_complexity = 13
max_code_line_length = 160
max_comment_line_length = 160
exclude_files = {
    "quanta/tools/lmake/share.lua",
    "quanta/server/center/page/*",
    "quanta/server/robot/accord/page/*"
}
include_files = {
    "server/*",
    "client/*",
    "quanta/script/*",
    "quanta/server/*",
    "quanta/tools/*/*.lua"
}
ignore = {"143", "212", "213", "512"}

