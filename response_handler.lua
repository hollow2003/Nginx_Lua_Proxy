-- Lua 脚本用于处理响应数据

-- 获取响应数据
local body = ngx.arg[1]
ngx.log(ngx.ERR, "Response bodyk: ", body)
-- 将响应数据中的小写字母转换为大写字母
body = string.upper(body)

-- 更新响应数据
ngx.arg[1] = body
