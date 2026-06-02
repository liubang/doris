"""Pattern generator rule for Doris FE Nereids pattern code generation.

This rule runs the PatternGeneratorMain tool to analyze Java source files
and generate pattern-related Java source files:
  - GeneratedMemoPatterns.java
  - GeneratedPlanPatterns.java
  - GeneratedExpressionRelations.java
  - GeneratedPlanRelations.java
"""

def _pattern_generator_impl(ctx):
    """Run PatternGeneratorMain to generate pattern source files."""
    output_srcjar = ctx.actions.declare_file(ctx.attr.name + ".srcjar")
    tool = ctx.executable.tool
    srcs = ctx.files.srcs

    # Build the command:
    # 1. Create a temp directory to hold source files in proper structure
    # 2. Copy source files preserving their package structure
    # 3. Run the generator tool
    # 4. Package output as srcjar
    cmd_parts = []
    cmd_parts.append("set -e")
    cmd_parts.append("EXEC_ROOT=$PWD")
    cmd_parts.append("SRCDIR=$(mktemp -d)")
    cmd_parts.append("OUTDIR=$(mktemp -d)")

    # Copy all nereids source files to temp dir preserving directory structure.
    # The generator needs to scan the directory tree to find all Java files.
    # Source files have paths like:
    #   fe/fe-core/src/main/java/org/apache/doris/nereids/.../*.java
    # We need to reconstruct the directory tree under SRCDIR.
    for src in srcs:
        # Extract the path relative to fe/fe-core/src/main/java/org/apache/doris/nereids/
        # The tool expects a directory path to scan recursively
        cmd_parts.append("mkdir -p $SRCDIR/$(dirname {path})".format(path = src.path))
        cmd_parts.append("cp $EXEC_ROOT/{path} $SRCDIR/{path}".format(path = src.path))

    # The source directory to pass to the generator
    # All nereids sources are under fe/fe-core/src/main/java/org/apache/doris/nereids/
    src_path = "$SRCDIR/fe/fe-core/src/main/java/org/apache/doris/nereids"

    # Run the pattern generator tool
    cmd_parts.append("$EXEC_ROOT/{tool} {src_path} $OUTDIR".format(
        tool = tool.path,
        src_path = src_path,
    ))

    # Package generated files as srcjar with proper package directory
    cmd_parts.append("mkdir -p $OUTDIR/org/apache/doris/nereids/pattern")
    cmd_parts.append("mv $OUTDIR/Generated*.java $OUTDIR/org/apache/doris/nereids/pattern/ 2>/dev/null || true")
    cmd_parts.append("cd $OUTDIR")
    cmd_parts.append("zip -r $EXEC_ROOT/{output} org/ -i '*.java'".format(output = output_srcjar.path))
    cmd_parts.append("cd $EXEC_ROOT")
    cmd_parts.append("rm -rf $SRCDIR $OUTDIR")

    ctx.actions.run_shell(
        outputs = [output_srcjar],
        inputs = srcs,
        tools = [tool],
        command = "\n".join(cmd_parts),
        mnemonic = "PatternGenerator",
        progress_message = "Generating Nereids pattern source files: %s" % ctx.label,
    )

    return [DefaultInfo(files = depset([output_srcjar]))]

pattern_generator = rule(
    implementation = _pattern_generator_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = [".java"]),
        "tool": attr.label(
            mandatory = True,
            executable = True,
            cfg = "exec",
        ),
    },
)
