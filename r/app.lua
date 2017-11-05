

-- add a new directory to the path
package.path = package.path .. ";./pl/?.lua"
package.path = package.path .. ";./lua_modules/share/lua/5.1/?.lua"

local cjson = require "cjson"
local pretty = require 'pl.pretty'
local stringx = require 'pl.stringx'
local seq = require( 'pl.seq' )
local tablex = require( 'tablex' )

function read_px_file( doc )
	-- read file, split into header and data part

	d = io.open(doc):read('*a')

	meta, d = unpack(stringx.split(d, 'DATA='))

	data = stringx.split(stringx.strip(d), '\n')

	res = {}

	for i = 1, #data do
		if data[i] ~= "" then
			res[i] = stringx.split(data[i])
		end
	end

	return res

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

local M = {}

function M.get_meta()

	-- respond to request for PX file description

	-- require('resty.repl').start()

	ngx.header.content_type = "application/json"
	
	res = read_px_file('data/d.txt')

	ngx.say(cjson.encode(res))
	

end

function bad_req_response()
	ngx.status = ngx.HTTP_BAD_REQUEST
	ngx.say("problem")
	ngx.exit(ngx.HTTP_OK)
end

function M.get_data()
	-- respond to requests for matrix subset

	query = ngx.req.get_uri_args()

	if (query.rows == nil or string.len(query.rows) == 0) 
	then
		bad_req_response()
	end
	if (query.cols == nil or string.len(query.cols) == 0) 
	then
		bad_req_response()
	end

	rows = cjson.decode(query.rows)
	cols = cjson.decode(query.cols)

	ngx.say(cjson.encode({rows, cols}))

end

function M.root()
	ngx.say('jei!')
end

return M
