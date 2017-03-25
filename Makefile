PROJECT = weekonekt 
PROJECT_DESCRIPTION = weekonet
PROJECT_VERSION = 0.0.1
DEPS = cowboy poolboy eredis jiffy uuid erlpass ebus jwt
dep_cowboy_commit = master
dep_uuid = git https://github.com/avtobiff/erlang-uuid.git v0.4.7
dep_ebus = git https://github.com/cabol/erlbus master
dep_jwt = git https://github.com/artemeff/jwt master
DEP_PLUGINS = cowboy
include erlang.mk
