-module(riakcp_sup).
-author('Martynas Pumputis <martynasp@gmail.com>').

-behaviour(supervisor).

-include_lib("riakc_pool/include/riakcp.hrl").

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%%%============================================================================
%%% API functions
%%%============================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%%%============================================================================
%%% Supervisor callbacks
%%%============================================================================

init([]) ->
    PoolSpecs = get_pool_child_specs(application:get_env(?APP, pools, [])),
    {ok, {{one_for_one, 1, 10}, PoolSpecs}}.

get_pool_child_specs(AppEnv) ->
    [get_pool_child_spec(Pool) || Pool <- AppEnv].

get_pool_child_spec({PoolName, Opts}) ->
    PoolSize = proplists:get_value(pool_size, Opts, ?POOL_SIZE),
    PoolMaxOverflow = proplists:get_value(pool_max_overflow, Opts, ?POOL_MAX_OVERFLOW),
    PoolArgs = [{name, {local, PoolName}},
                {worker_module, riakcp_worker},
                {size, PoolSize}, {max_overflow, PoolMaxOverflow}],

    RiakAddr = proplists:get_value(riak_address, Opts, ?RIAK_ADDR),
    RiakPort = proplists:get_value(riak_port, Opts, ?RIAK_PORT),
    RiakOpts = proplists:get_value(riak_options, Opts, []),
    RiakArgs = {RiakAddr, RiakPort, RiakOpts},

    poolboy:child_spec(PoolName, PoolArgs, RiakArgs).


%%%============================================================================
%%% Internal functions
%%%============================================================================
