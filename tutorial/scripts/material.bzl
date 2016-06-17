
def _fuse_shader_impl(ctx):
	pass

def _hash_fuse_shader_input_impl(ctx):
	pass

fuse_shader = rule(
	implementation = _fuse_shader_impl,
	attrs = {
		"shader": attr.label(allow_files = [".asl"], mandatory = True, single_file = True),
		"json_prms": attr.label(mandatory = True, single_file = True),
		"output": attr.output(mandatory = True),
	}
)

hash_fuse_shader_input = rule(
	implementation = _hash_fuse_shader_input_impl,
	attrs = {
		"shader": attr.label(allow_files = [".asl"], mandatory = True, single_file = True),
		"json_prms": attr.label(mandatory = True, single_file = True),
		"output": attr.output(mandatory = True),
	}
)


def rule_name(package_name):
	return package_name.replace("@", "").replace("//", "")

def rel_repo_path(label):
	index = label.find("//")
	return label[index + 2:]

def fuse_material_shaders( material_packages ):


	# Fuse individual shaders
	for material_package in material_packages:
		shader_path = "%s/shader.ae4shader" % rel_repo_path(material_package)
		fuse_shader(
			name = "%s_fuse_shader" % rule_name(material_package),
			shader = "%s:shaders" % material_package,
			json_prms = "%s:parameters" % material_package,
			output = shader_path,
		)
		hash_path = "%s.input.sha1" % shader_path

		hash_fuse_shader_input(
			name = "%s_hash_shader_input" % rule_name(material_package),
			shader = "%s:shaders" % material_package,
			json_prms = "%s:parameters" % material_package,
			output = hash_path,
		)

