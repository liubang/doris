"""ANTLR4 code generation rules for Doris FE."""

def _antlr4_java_srcjar_impl(ctx):
    """Generate Java source from ANTLR4 grammar files and package as srcjar."""
    output_srcjar = ctx.actions.declare_file(ctx.attr.name + ".srcjar")
    grammar_srcs = ctx.files.srcs
    import_grammars = ctx.files.imports
    package = ctx.attr.package
    package_dir = package.replace(".", "/")

    visitor_flag = "-visitor" if ctx.attr.visitor else "-no-visitor"
    listener_flag = "-listener" if ctx.attr.listener else "-no-listener"

    # Build the command
    cmd_parts = []
    cmd_parts.append("TMPDIR=$(mktemp -d)")
    cmd_parts.append("OUTDIR=$TMPDIR/{package_dir}".format(package_dir = package_dir))
    cmd_parts.append("mkdir -p $OUTDIR")
    cmd_parts.append("EXEC_ROOT=$PWD")

    # Run ANTLR4 tool
    antlr4_tool = ctx.executable._antlr4_tool

    # Copy all grammar files (srcs + imports) to OUTDIR so ANTLR4 can resolve imports and tokenVocab
    for src in grammar_srcs:
        cmd_parts.append("cp $EXEC_ROOT/{src} $OUTDIR/".format(src = src.path))
    for imp in import_grammars:
        cmd_parts.append("cp $EXEC_ROOT/{src} $OUTDIR/".format(src = imp.path))

    # Run ANTLR4 on each grammar file from within OUTDIR (only srcs, not imports)
    for src in grammar_srcs:
        basename = src.basename
        cmd_parts.append("cd $OUTDIR && $EXEC_ROOT/{antlr4} -Dlanguage=Java {visitor} {listener} -package {package} {basename}".format(
            antlr4 = antlr4_tool.path,
            visitor = visitor_flag,
            listener = listener_flag,
            package = package,
            basename = basename,
        ))
    cmd_parts.append("cd $EXEC_ROOT")

    # Remove .g4 and .tokens/.interp files, keep only .java
    cmd_parts.append("find $OUTDIR -name '*.g4' -delete")
    cmd_parts.append("find $OUTDIR -name '*.tokens' -delete")
    cmd_parts.append("find $OUTDIR -name '*.interp' -delete")

    # Package as srcjar
    cmd_parts.append("cd $TMPDIR")
    cmd_parts.append("zip -r $EXEC_ROOT/{output} . -i '*.java'".format(output = output_srcjar.path))
    cmd_parts.append("cd $EXEC_ROOT")
    cmd_parts.append("rm -rf $TMPDIR")

    ctx.actions.run_shell(
        outputs = [output_srcjar],
        inputs = grammar_srcs + import_grammars,
        tools = [antlr4_tool],
        command = "\n".join(cmd_parts),
        mnemonic = "Antlr4Java",
        progress_message = "Generating Java srcjar from ANTLR4 grammar: %s" % ctx.label,
    )

    return [DefaultInfo(files = depset([output_srcjar]))]

_antlr4_java_srcjar = rule(
    implementation = _antlr4_java_srcjar_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = [".g4"]),
        "imports": attr.label_list(allow_files = [".g4"], default = []),
        "package": attr.string(mandatory = True),
        "visitor": attr.bool(default = True),
        "listener": attr.bool(default = True),
        "_antlr4_tool": attr.label(
            default = "//tools/bazel:antlr4_tool",
            executable = True,
            cfg = "exec",
        ),
    },
)

def antlr4_java_library(name, srcs, package, imports = [], deps = [], visitor = True, listener = True, visibility = None):
    """Generate Java source from ANTLR4 grammar files and compile as java_library.

    Args:
        name: target name
        srcs: list of .g4 grammar files to generate code from
        package: Java package for generated code
        imports: additional .g4 files needed for import/tokenVocab resolution (not compiled)
        deps: additional Java library dependencies
        visitor: whether to generate visitor classes
        listener: whether to generate listener classes
        visibility: visibility specification
    """
    gen_name = name + "_gen"

    _antlr4_java_srcjar(
        name = gen_name,
        srcs = srcs,
        imports = imports,
        package = package,
        visitor = visitor,
        listener = listener,
    )

    native.java_library(
        name = name,
        srcs = [gen_name],
        deps = [
            "@maven//:org_antlr_antlr4_runtime",
        ] + deps,
        visibility = visibility,
    )
