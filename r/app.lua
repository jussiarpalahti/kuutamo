

-- add a new directory to the path
package.path = package.path .. ";./pl/?.lua"
package.path = package.path .. ";./lua_modules/share/lua/5.1/?.lua"

local cjson = require "cjson"
local pretty = require 'pl.pretty'
local stringx = require 'pl.stringx'
local seq = require( 'pl.seq' )
local tablex = require( 'tablex' )

function read_px_file( ... )
	-- read file, split into header and data part
end

function parse_meta( ... )
	-- meta to table
end

function parse_data( ... )
	-- data to matrix
end

function select_data( ... )
	-- row and col index lists to matrix subset
end


function get_meta()

	-- respond to request for PX file description

	d = io.open('data/d.txt'):read('*a')

	ngx.header.content_type = "application/json"
	
	res = {}
	l = stringx.split(d, '\n')

	for i = 1, #l do
		if l[i] ~= "" then
			res[i] = stringx.split(l[i])
		end
	end


	ngx.say(cjson.encode(res))
	

end


function get_data( ... )
	-- respond to requests for matrix subset
end


get_meta();
