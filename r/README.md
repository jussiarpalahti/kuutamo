
# OpenResty Lua exploration

## Get started

I haven't quite figured out how to get Penlight installed locally. Probably the same way that lua-resty-repl happened. Anyway, it needs to be somewhere: https://github.com/stevedonovan/Penlight.git

 brew install homebrew/nginx/openresty lua@5.1 fswatch

## Openresty

 * ```openresty -p `pwd` -c conf/nginx.conf```
 * also same with -s to signal reload
 * though with `daemon off` configuration keeps it running in foreground so shutdown is mere C-c away

## Repl

 * Installation: 
  * `/usr/local/bin/luarocks-5.1 install --local lua-resty-repl`
  * `/usr/local/bin/luarocks-5.1 install --tree lua_modules lua-resty-repl`
  * both aren't probably necessary but what do I know
 * `rlwrap lua_modules/bin/resty-repl` <- this starts the REPL standalone
 * `require('resty.repl').start()` <- this one goes to Lua running inside Openresty

## When debugging

 * When fiddling around the debugger it's nice to have a request still to respond to `http --timeout 240 dev:9000`

## Livereload

 * `fswatch -o app.lua | xargs -n1 -I{} http dev:9000`
  * this way changes in the app are shown in short time in the console
  * very simple way to keep checking how API or anything else gets developed
  * probably should add some tests the same way
