--service_cfg.lua
--source: service.csv
--luacheck: ignore 631

--获取配置表
local config_mgr = quanta.get("config_mgr")
local service = config_mgr:get_table("service")

--导出配置内容
service:upsert({
    enable=true,
    enum_key='XLUA',
    id=32,
    name='xlua'
})

service:update()
