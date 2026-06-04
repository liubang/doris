"""Bazel rule for generating C++ code from Thrift IDL files.

Generates C++ source files using the Thrift compiler with options matching
the original Doris build: --gen cpp:moveable_types,no_skeleton

Generated files are placed under a gen_cpp/ subdirectory so that
BE source code can use #include <gen_cpp/xxx_types.h>.
"""

def _thrift_cpp_library_impl(ctx):
    """Implementation of thrift_cpp_library rule."""
    src_files = ctx.files.srcs
    thrift_files = ctx.files._thrift_compiler

    # Find the thrift binary from the filegroup
    thrift_compiler = None
    for f in thrift_files:
        if f.basename == "thrift":
            thrift_compiler = f
            break
    if not thrift_compiler:
        fail("Could not find thrift binary in @thrift_cpp//:thrift_compiler")

    # Create output directory (tree artifact)
    out_dir = ctx.actions.declare_directory(ctx.label.name + "_gen")

    # Build thrift include paths
    thrift_includes = []
    for src in src_files:
        dir_path = src.dirname
        if dir_path not in thrift_includes:
            thrift_includes.append(dir_path)

    # Run thrift compiler for each source file, output to gen_cpp/ subdir
    cmds = [
        "chmod +x " + thrift_compiler.path,
        "mkdir -p " + out_dir.path + "/gen_cpp",
    ]
    for src in src_files:
        cmd = "{thrift} --gen cpp:moveable_types,no_skeleton --allow-64bit-consts -strict -out {out_dir}/gen_cpp".format(
            thrift = thrift_compiler.path,
            out_dir = out_dir.path,
        )
        for inc in thrift_includes:
            cmd += " -I " + inc
        cmd += " " + src.path
        cmds.append(cmd)

    ctx.actions.run_shell(
        inputs = src_files + thrift_files,
        outputs = [out_dir],
        command = " && ".join(cmds),
        mnemonic = "ThriftCppGen",
        progress_message = "Generating C++ from %d Thrift files" % len(src_files),
    )

    # Create cc_library compilation context
    # The include path is set to the output directory root, so
    # #include <gen_cpp/xxx_types.h> resolves correctly.
    compilation_context = cc_common.create_compilation_context(
        headers = depset([out_dir]),
        includes = depset([out_dir.path]),
    )

    return [
        DefaultInfo(files = depset([out_dir])),
        CcInfo(compilation_context = compilation_context),
    ]

thrift_cpp_library = rule(
    implementation = _thrift_cpp_library_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = [".thrift"],
            mandatory = True,
            doc = "Thrift IDL source files",
        ),
        "thrift_path": attr.string(
            doc = "Import path for thrift files",
        ),
        "deps": attr.label_list(
            providers = [CcInfo],
            doc = "Dependencies (other thrift_cpp_library targets)",
        ),
        "_thrift_compiler": attr.label(
            default = "@thrift_cpp//:thrift_compiler",
            doc = "Thrift compiler binary",
        ),
    },
    provides = [CcInfo],
    doc = "Generates a C++ library from Thrift IDL files.",
)
