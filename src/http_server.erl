-module(http_server).
-export([
         start/2, init/2, info/3
        ]).

routes(App, Handler) -> 
  [
    {"/api/[...]", http_server, [Handler]},
    {"/", cowboy_static, {priv_file, App, "index.html"}},
    {"/[...]", cowboy_static, {priv_dir, App, "."}}
  ].

start(App, Handler) -> 
  Dispatch = cowboy_router:compile([{'_', routes(App, Handler)}]),
  {ok, _} = cowboy:start_clear(my_http_listener, 100,
                               [{port, 8080}],
                               #{env => #{dispatch => Dispatch}}
                              ).


init(Req, [Handler]) ->
  PathInfo = cowboy_req:path_info(Req),
  [Spec]=Handler:do(PathInfo),
  case Spec of
    {_Role, Act} ->
      ok(app, user, [], Act, Req, Spec);
    {_Role, Params, Act} -> 
      case input(Params, Req) of
        {invalid, K} -> invalid(Req, K);
        Input ->
          ok(app, user, Input, Act, Req, Spec)
      end;
    {_Role, Params, Act, _} ->
      case input(Params, Req) of
        {invalid, K} -> invalid(Req, K);
        Input ->
          loop(app, user, Input, Act, Req, Spec)
      end;
    _ -> not_found(Req)
  end.

info(Msg, Req, Spec) ->
  {_, _, _, React} = Spec,
  case React(app, user, params, Msg) of 
    {ok, Body} -> 
      {stop, ok(Body, [], Req), Spec};
    forbidden -> 
      {stop, forbidden(Req), Spec};
    continue ->
      {ok, Req, Spec}
  end.


ok(App, User, Params, Act, Req, State) ->
  case Act(App, User, Params) of
    {error, E} -> 
      {ok, reply(500, E, [], Req), State};
    {ok, B} -> 
      {ok, reply(200, B, [], Req), State}
  end.

loop(App, User, Params, Act, Req, State) ->
  Act(App, User, Params),
  {cowboy_loop, Req, State}.

ok(Body, _Headers, Req) ->
  reply(200, Body, [], Req).

forbidden(Req) -> reply(403, Req).
not_found(Req) -> reply(404, Req).
invalid(Req, R) -> reply(400, #{reason => R}, [], Req).

reply(Status, Req) ->
  reply(Status, [], [], Req).

reply(Status, Body, _Headers, Req) ->
  cowboy_req:reply(Status, #{
                     <<"content-type">> => <<"application/json">>
                    }, jiffy:encode(Body), Req).


input([], _Req) -> [];

input(Spec, Req) ->
  case cowboy_req:has_body(Req) of
    false -> invalid(Req, missing_body);
    true ->
      {ok, Body, Req2} = cowboy_req:read_body(Req),
      case cowboy_req:header(<<"content-type">>, Req2) of
        <<"application/json">> ->
          Json = jiffy:decode(Body, [return_maps]),
          parse_input(Spec, Json);        
        _ -> invalid(Req2, content_type)
      end
  end.   


parse_input(Spec, Json) ->
  parse_input(Spec, [], Json).

parse_input([{Type, K} |Rest], SoFar, Json) ->
  case parse_value(Type, K, Json) of
    invalid -> {invalid, K};
    missing -> {invalid, K};
    V -> parse_input(Rest, [V|SoFar], Json)
  end;

parse_input([{Type, K, Default} |Rest], SoFar, Json) ->
  case parse_value(Type, K, Json) of
    invalid -> {invalid, K};
    missing -> parse_input(Rest, [Default|SoFar], Json);
    V -> parse_input(Rest, [V|SoFar], Json)
  end;
  
parse_input([], SoFar, _) -> lists:reverse(SoFar).

parse_value(Type, [K|Rest], Json) ->
  case maps:is_key(K, Json) of
    false -> {missing, K};
    true -> 
      parse_value(Type, Rest, maps:get(K, Json))
  end;


parse_value(Type, K, Json) ->
  case maps:is_key(K, Json) of
    false -> {missing, K};
    true ->
      parse_actual(Type, K, Json)
  end.

parse_actual(text, K, Json) ->
  case maps:get(K, Json) of
    V when is_binary(V) -> V;
    _ -> {invalid, K}
  end.

