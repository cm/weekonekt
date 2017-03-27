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

REL_NAME = weekonekt 
REL_DIR = _rel/$REL_NAME_release/releases/0.0.1

quick:
	  @erl +pc unicode -smp enable -sname weekonekt -boot _rel/weekonekt_release/releases/0.0.1/weekonekt_release -config rel/sys.config -env ERL_LIBS _rel/weekonekt_release/lib
