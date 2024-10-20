-module(remindme_app).

-import(calendar, [
    datetime_to_gregorian_seconds/1,
    local_time/0
]).

-export([start/2, start_link/2, cancel/1]).
-export([init/3, loop/1]).

-record(state, {server,
                name = "",
                to_go = 0}).

%%====================================================================
%% Public API
%%====================================================================

start(EventName, DateTime) ->
    spawn(?MODULE, init, [self(), EventName, DateTime]).


start_link(EventName, DateTime) ->
    spawn_link(?MODULE, init, [self(), EventName, DateTime]).


cancel(Pid) ->
    Ref = erlang:monitor(process, Pid),
    Pid ! {self(), Ref, cancel},
    receive
        {Ref, ok} ->
            erlang:demonitor(Ref, [flush]),
            ok;
        {'DOWN', Ref, process, Pid, _Reason} ->
            ok
    end.


init(Server, EventName, DateTime) ->
    loop(#state{server = Server,
                name = EventName,
                to_go = humanized(DateTime)}).


loop(S = #state{server = Server, to_go = [T | Next]}) ->
    receive
        {Server, Ref, cancel} ->
            Server ! {Ref, ok}
    after T * 1000 ->
        if Next =:= [] ->
            Server ! {done, S#state.name};
            Next =/= [] ->
                loop(S#state{to_go = Next})
        end
    end.

%%====================================================================
%% Internal utilities
%%====================================================================

humanized(TimeOut = {{_, _, _}, {_, _, _}}) ->
    ToGo = datetime_to_gregorian_seconds(TimeOut) -
           datetime_to_gregorian_seconds(local_time()),

    Seconds =
    if
        ToGo > 0 -> ToGo;
        ToGo =< 0 -> 0
    end,

    Limit = 49 * 24 * 3600,
    [Seconds rem Limit | lists:duplicate(Seconds div Limit, Limit)].
