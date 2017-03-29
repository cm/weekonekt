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

dev_rel:
	@rm *.dump
	@rm -rf run/*.boot
	@rm -rf run/*.script
	@rm -rf run/*.rel
	@cp _rel/weekonekt_release/releases/0.0.1/weekonekt_release.rel run/weekonekt.rel
	@cd run; erl -noshell -pa ~/Projects/weekonekt/ebin -pa ~/Projects/weekonekt/deps/*/ebin -eval 'systools:make_script("weekonekt", [local]),init:stop().'; cd ..

dev:
	@erl +pc unicode -smp enable -sname weekonekt -boot run/weekonekt -config rel/sys

