-module(api).
-export([do/1]).

do([<<"info">>]) ->
  [{ everybody, fun(_, _, []) ->
                    {ok, #{ roles => [visitor] }}
                end}];


do([<<"location">>, <<"search">>]) ->
  [{ anonymous, [{text, <<"keywords">>}],
     fun(_, _, [Keywords]) ->  
         ebus:sub(self(), locations_results),
         ebus:pub(locations_query, {kw, Keywords}),
         ebus:pub(locations_results, [#{name => Keywords}])
     end,
     fun(_, _, _,[Locations]) -> 
         {ok, Locations}
     end
   }
  ];

do([<<"category">>, <<"search">>]) ->
  [{ anonymous, [{text, [<<"location">>, <<"id">>]}],
     fun(_, _, [LocationId]) ->  
         ebus:sub(self(), categories),
         ebus:pub(categories_q, {location, LocationId}),
         ebus:pub(categories, [#{name => accomodation}])
     end,
     fun(_, _, _,[Categories]) -> 
         {ok, Categories}
     end
   }
  ];

do([<<"recommendation">>, <<"search">>]) ->
  [{ anonymous, [{list, <<"options">>, []}],
     fun(_, _, [Options]) ->  
         ebus:sub(self(), recommendations),
         ebus:pub(recommendations_q, {options, Options}),
         ebus:pub(recommendations, [#{name => spain}])
     end,
     fun(_, _, _,[Options]) -> 
         {ok, Options}
     end
   }
  ];


do(_) -> not_implemented.
