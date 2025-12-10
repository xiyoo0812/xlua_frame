self=false
stds.quanta = {
    globals = {
        --common
        "coroutine", "qtable", "qstring", "qmath", "ncmd_cs",
        "import", "class", "enum", "mixin", "property", "singleton", "super", "implemented",
        "quanta", "environ", "signal", "http", "guid", "service", "logger", "utility", "platform", "storage",
        "logfeature", "classof", "is_class", "is_subclass", "instanceof", "conv_class", "class_review",
        "codec", "stdfs", "luabus", "luakit", "json", "protobuf", "timer", "log", "worker", "http", "bson", "ssl", "zip"
    }
}
std = "max+quanta"
max_cyclomatic_complexity = 13
max_code_line_length = 160
max_comment_line_length = 160
exclude_files = {
    "quanta/server/center/page/*",
    "server/robot/accord/page/*"
}
include_files = {
    "server/*",
    "quanta/script/*",
    "quanta/server/*",
}
ignore = {"212", "213", "512"}

