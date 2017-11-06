

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

	meta_part, data_part = unpack(stringx.split(d, 'DATA='))

	return meta_part, data_part

end

function clean_value(value)
	-- get a list of strings from 
	-- a string of comma separated quoted strings

	lines = {}
	
	for s in value:gmatch('"(.-)"') do
		table.insert(lines, s) 
	end

	if #lines == 1 then 
		return lines[1]
	else
		return lines
	end

end

function parse_meta(meta_part)
	-- meta to table

	meta = {}

	-- RE_META = "(%a-)=(.-);\n"

	stripped = stringx.strip(meta_part)

	fields = stringx.split(stripped, ';\n')

    for l = 1, #fields do

    	field, value = unpack(stringx.split(fields[l], '=', 2))

    	if not stringx.startswith(field, 'NOTE') then
    		meta[field] = clean_value(value)
    	end
    end

	return meta

end

function parse_data(data_part)
	-- data to matrix

	data_lines = stringx.split(stringx.strip(data_part), '\n')

	data = {}

	for i = 1, #data_lines do
		if data_lines[i] ~= "" then
			data[i] = stringx.split(data_lines[i])
		end
	end
	
	return data

end

function select_data(data, rows, cols)
	-- row and col index lists to matrix subset
	
	res = {}

	for r = 1, #rows do
		res[r] = {}
		for c = 1, #cols do
			res[r][c] = data[rows[r]][cols[c]]
		end
	end

	return res

end

local M = {}

function M.get_meta()

	-- respond to request for PX file description
	
	meta_part, data = read_px_file('data/pd.px')

	meta = parse_meta(meta_part)

	ngx.header.content_type = "application/json"

	ngx.say(cjson.encode(meta))
	
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
	
	meta, data = read_px_file('data/pd.px')

	res = select_data(parse_data(data), rows, cols)

	ngx.header.content_type = "application/json"

	ngx.say(cjson.encode(res))

end

function M.root()
	ngx.say('jei!')
end
	
-- require('resty.repl').start()

return M
