NOTE this is just a quick hack where I've modified the code to support multiple
pools. This repo will most likely dissappear again soon.

# riakc\_pool

(Really) simple Erlang Riak client process pool based on
[riak-erlang-client][2] and [poolboy][3].

[![Build Status](https://travis-ci.org/brb/riakc_pool.png)](https://travis-ci.org/brb/riakc_pool)

## Dependencies

* Erlang (>= R15B01)
* [rebar][1]

## Setup

`make all`

## Configuration

```erlang
[
    {riakc_pool,
     [{pools,
       [{pool1,
         [{pool_size, 30},
          {pool_max_overflow, 5},
          {riak_address, "10.0.0.1"},
          {riak_port, 8087}]},
        {pool2,
         [{pool_size, 10},
          {pool_max_overflow, 5},
          {riak_address, "10.0.0.2"},
          {riak_port, 8087}]}]}]}

]
```

## Running application

`application:start(riakc_pool)`

## Usage

* `riakcp:exec(PoolName, Function, Args)`, where `PoolName` is the name of the
pool, `Function` is a `riakc_pb_socket` module function name and `Args` is a
list of its parameters excluding `Pid`.

[1]: https://github.com/rebar/rebar
[2]: https://github.com/basho/riak-erlang-client
[3]: https://github.com/devinus/poolboy
