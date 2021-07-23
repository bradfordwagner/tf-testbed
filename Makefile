

plan:
	@terraform plan

d: dev
g: generate
c: clean

# watch / develop
dev_pipeline: plan
watch:
	@watchexec -cr -w . -w Makefile -- make dev_pipeline
dev: watch
