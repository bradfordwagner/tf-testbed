d: dev

plan:
	@task tf_apply

# watch / develop
dev_pipeline: plan
watch:
	@watchexec -c -r -w . -w Makefile -w Taskfile.yml -- make dev_pipeline
dev: watch
