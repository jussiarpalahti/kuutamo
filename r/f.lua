
print(package.path) -- where .lua files are searched for
print(package.cpath) -- where native modules are searched for

-- add a new directory to the path
package.path = package.path .. ";./pl/?.lua"

local utils = require 'pl.utils'

utils.printf("%s\n","That feels better")
