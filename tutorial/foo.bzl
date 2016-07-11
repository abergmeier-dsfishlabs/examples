
def _impl(repository_ctx):
	repository_ctx.symlink(Label(repository_ctx.attr.build_path), "source")

foo_repository = repository_rule(
	implementation = _impl,
	attrs = {
		"build_path": attr.string(mandatory=True),
	},
)
