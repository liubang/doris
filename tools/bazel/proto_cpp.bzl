"""Bazel rule for generating C++ code from Protocol Buffer files.

Uses protobuf 21.x protoc (from @protobuf_21) to generate C++ code
compatible with the brpc/BE runtime.

Generated files are placed under a gen_cpp/ subdirectory so that
BE source code can use #include <gen_cpp/xxx.pb.h>.
"""

def _doris_cc_proto_library_impl(ctx):
    """Implementation of doris_cc_proto_library rule."""
    src_files = ctx.files.srcs
    protoc_files = ctx.files._protoc

    # Find the protoc binary from the filegroup
    protoc = None
    for f in protoc_files:
        if f.basename == "protoc":
            protoc = f
            break
    if not protoc:
        fail("Could not find protoc binary in @protobuf_21//:protoc")

    # Create output directory (tree artifact)
    out_dir = ctx.actions.declare_directory(ctx.label.name + "_gen")

    # Build proto include paths
    proto_includes = []
    for src in src_files:
        dir_path = src.dirname
        if dir_path not in proto_includes:
            proto_includes.append(dir_path)

    # Run protoc for each source file, output to gen_cpp/ subdir
    cmds = [
        "chmod +x " + protoc.path,
        "mkdir -p " + out_dir.path + "/gen_cpp",
    ]
    for src in src_files:
        cmd = "{protoc} --cpp_out={out_dir}/gen_cpp".format(
            protoc = protoc.path,
            out_dir = out_dir.path,
        )
        for inc in proto_includes:
            cmd += " --proto_path=" + inc
        cmd += " " + src.path
        cmds.append(cmd)

    ctx.actions.run_shell(
        inputs = src_files + protoc_files,
        outputs = [out_dir],
        command = " && ".join(cmds),
        mnemonic = "ProtoCppGen",
        progress_message = "Generating C++ from %d proto files" % len(src_files),
    )

    # Create cc_library compilation context
    # The include path is set to the output directory root, so
    # #include <gen_cpp/xxx.pb.h> resolves correctly.
    compilation_context = cc_common.create_compilation_context(
        headers = depset([out_dir]),
        includes = depset([out_dir.path]),
    )

    return [
        DefaultInfo(files = depset([out_dir])),
        CcInfo(compilation_context = compilation_context),
    ]

doris_cc_proto_library = rule(
    implementation = _doris_cc_proto_library_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = [".proto"],
            mandatory = True,
            doc = "Protocol Buffer source files",
        ),
        "proto_path": attr.string(
            doc = "Import path for proto files",
        ),
        "deps": attr.label_list(
            providers = [CcInfo],
            doc = "Dependencies (other proto libraries)",
        ),
        "_protoc": attr.label(
            default = "@protobuf_21//:protoc",
            doc = "Protocol Buffer compiler (protoc 21.x)",
        ),
    },
    provides = [CcInfo],
    doc = "Generates a C++ library from Protocol Buffer files using protoc 21.x.",
)
