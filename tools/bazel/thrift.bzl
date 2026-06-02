"""Thrift code generation rules for Doris FE."""

def _thrift_java_srcjar_impl(ctx):
    """Generate Java source from .thrift files and package as srcjar."""
    output_srcjar = ctx.actions.declare_file(ctx.attr.name + ".srcjar")
    thrift_srcs = ctx.files.srcs
    thrift_includes = ctx.files.includes

    # 构建 include 路径参数
    include_args = []
    include_dirs = {}
    for inc in thrift_includes:
        d = inc.dirname
        if d not in include_dirs:
            include_dirs[d] = True
            include_args.extend(["-I", d])

    for src in thrift_srcs:
        d = src.dirname
        if d not in include_dirs:
            include_dirs[d] = True
            include_args.extend(["-I", d])

    # 构建 shell 脚本来生成代码并打包为 srcjar
    cmd_parts = []
    cmd_parts.append("TMPDIR=$(mktemp -d)")

    # 对每个 thrift 文件运行 thrift 编译器 (fullcamel 生成 JavaBean 风格的驼峰命名)
    for src in thrift_srcs:
        cmd_parts.append("{thrift} --gen java:fullcamel -out $TMPDIR {includes} {src}".format(
            thrift = ctx.executable.thrift_compiler.path,
            includes = " ".join(include_args),
            src = src.path,
        ))

    # 打包为 srcjar (zip) - 使用绝对路径因为会 cd 到 TMPDIR
    cmd_parts.append("ORIG_DIR=$PWD")
    cmd_parts.append("cd $TMPDIR")
    cmd_parts.append("zip -r $ORIG_DIR/{output} . -i '*.java'".format(output = output_srcjar.path))
    cmd_parts.append("cd $ORIG_DIR")
    cmd_parts.append("rm -rf $TMPDIR")

    ctx.actions.run_shell(
        outputs = [output_srcjar],
        inputs = thrift_srcs + thrift_includes,
        tools = [ctx.executable.thrift_compiler],
        command = "\n".join(cmd_parts),
        mnemonic = "ThriftJava",
        progress_message = "Generating Java srcjar from Thrift: %s" % ctx.label,
    )

    return [DefaultInfo(files = depset([output_srcjar]))]

_thrift_java_srcjar = rule(
    implementation = _thrift_java_srcjar_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = [".thrift"]),
        "includes": attr.label_list(allow_files = [".thrift"]),
        "thrift_compiler": attr.label(
            executable = True,
            cfg = "exec",
            allow_single_file = True,
        ),
    },
)

def thrift_java_library(name, srcs, includes = [], thrift_compiler = None, deps = [], visibility = None):
    """Macro: generate Java library from Thrift IDL files.

    Args:
        name: target name
        srcs: list of .thrift source files
        includes: additional .thrift files for include resolution
        thrift_compiler: label of the thrift compiler binary
        deps: additional Java library dependencies
        visibility: visibility specification
    """
    gen_name = name + "_srcjar"

    _thrift_java_srcjar(
        name = gen_name,
        srcs = srcs,
        includes = includes,
        thrift_compiler = thrift_compiler,
    )

    native.java_library(
        name = name,
        srcs = [gen_name],
        deps = [
            "@maven//:javax_annotation_javax_annotation_api",
            "@maven//:org_apache_thrift_libthrift",
            "@maven//:org_slf4j_slf4j_api",
        ] + deps,
        visibility = visibility,
    )
