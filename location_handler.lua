local ffi = require("ffi")
local json = require("cjson")
local lib = ffi.load("/home/hpr/libexample.so")
ffi.cdef[[
     float add(float a, float b);
     const char* cjson_encode(const void* obj);
     void* cjson_decode(const char* json);
 ]]
local chunk, eof = ngx.arg[1], ngx.arg[2]
local buffered = ngx.ctx.buffered
if not buffered then
   buffered = {}  -- XXX we can use table.new here 
   ngx.ctx.buffered = buffered
end
if chunk ~= "" then
   buffered[#buffered + 1] = chunk
   ngx.arg[1] = nil
end
if eof then
   local whole = table.concat(buffered)
   ngx.ctx.buffered = nil
   ngx.log(ngx.ERR, "whole type: " .. type(whole))
   local body = json.decode(whole)
   ngx.log(ngx.ERR, "body type: " .. type(body))
   if type(body) == "table" then
	-- 检查 body.x 和 body.y 是否是浮点数类型
-- 	ngx.log(ngx.ERR, "Error: body.x or body.y is not a number. body.x type: " .. type(whole.x) .. ", value: " .. tostring(whole.x) .. ", body.y type: " .. type(whole.y) .. ", value: " .. tostring(whole.y))
       if type(body.x) == "number" and type(body.y) == "number" then
	    -- 执行加法操作
           body["x+y"] = lib.add(body.x, body.y)
	    -- 移除原始数据中的 x 和 y
           body.x = nil
           body.y = nil
           ngx.arg[1] = json.encode(body)
--         ngx.log(ngx.ERR, "Error: body.x or body.y is not a number. body.x type: " .. type(body.x) .. ", value: " .. tostring(body.x) .. ", body.y type: " .. type(body.y) .. ", value: " .. tostring(body.y))
   	end
   end
-- 	ngx.arg[1] = whole
end
-- else
-- 	ngx.log(ngx.ERR, "json_str is nil")
-- end
-- 更新响应数据
-- ngx.arg[1] = body1

