

-- add a new directory to the path
package.path = package.path .. ";./pl/?.lua"
package.path = package.path .. ";./lua_modules/share/lua/5.1/?.lua"

local cjson = require "cjson"

local pretty = require 'pl.pretty'


function render()

	t = {key1 = 'value1', key2 = false, key3 = 'jee'}

	ngx.header.content_type = "application/json"
	
	ngx.say(cjson.encode(t))
	
	-- require('resty.repl').start()

end
