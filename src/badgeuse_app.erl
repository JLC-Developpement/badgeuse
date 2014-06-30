-module(badgeuse_app).
-behavior(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
    Dispatch = cowboy_router:compile([
        	{'_', [
            {"/", cowboy_static, {priv_file, badgeuse, "index.html"}},
            {"/ws", badgeuse_handler, []},
            {"/static/[...]", cowboy_static, {priv_dir, badgeuse, "static"}}
          ]}
    ]),
    %% Name, NbAcceptors, TransOpts, ProtoOpts
    cowboy:start_http(my_http_listener, 100,
        [{port, 8080}],
        [{env, [{dispatch, Dispatch}]}]
    ),
    badgeuse_sup:start_link().

stop(_State) ->
    ok.
