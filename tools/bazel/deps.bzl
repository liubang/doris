"""External binary tool dependencies for code generation."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")

def _grpc_java_plugin_repo_impl(repository_ctx):
    """Download the correct grpc-java protoc plugin for the host platform."""
    os_name = repository_ctx.os.name.lower()
    os_arch = repository_ctx.os.arch

    version = "1.65.1"
    base_url = "https://repo1.maven.org/maven2/io/grpc/protoc-gen-grpc-java/{version}/protoc-gen-grpc-java-{version}-".format(version = version)

    if "mac" in os_name or "darwin" in os_name:
        if "aarch64" in os_arch or "arm64" in os_arch:
            url = base_url + "osx-aarch_64.exe"
        else:
            url = base_url + "osx-x86_64.exe"
    elif "linux" in os_name:
        if "aarch64" in os_arch or "arm64" in os_arch:
            url = base_url + "linux-aarch_64.exe"
        else:
            url = base_url + "linux-x86_64.exe"
    else:
        fail("Unsupported platform: %s/%s" % (os_name, os_arch))

    repository_ctx.download(
        url = url,
        output = "protoc-gen-grpc-java",
        executable = True,
    )

    repository_ctx.file("BUILD.bazel", content = """
package(default_visibility = ["//visibility:public"])
exports_files(["protoc-gen-grpc-java"])
""")

grpc_java_plugin_repo = repository_rule(
    implementation = _grpc_java_plugin_repo_impl,
    local = True,
)

def _thrift_compiler_repo_impl(repository_ctx):
    """Locate thrift 0.16.0 compiler - use bundled binary or fall back to PATH."""
    os_name = repository_ctx.os.name.lower()
    os_arch = repository_ctx.os.arch

    # Determine platform-specific binary name
    if "mac" in os_name or "darwin" in os_name:
        if "aarch64" in os_arch or "arm64" in os_arch:
            platform = "darwin-arm64"
        else:
            platform = "darwin-x86_64"
    elif "linux" in os_name:
        if "aarch64" in os_arch or "arm64" in os_arch:
            platform = "linux-arm64"
        else:
            platform = "linux-x86_64"
    else:
        platform = None

    # Try bundled binary first
    bundled = None
    if platform:
        bundled_path = repository_ctx.path(
            repository_ctx.attr._workspace_root,
        ).dirname.get_child("tools").get_child("bin").get_child(
            "thrift-0.16.0-" + platform,
        )
        if bundled_path.exists:
            bundled = bundled_path

    if bundled:
        repository_ctx.symlink(bundled, "thrift")
    else:
        # Fall back to system PATH
        thrift_path = repository_ctx.which("thrift")
        if thrift_path == None:
            fail(
                "Thrift 0.16.0 compiler not found.\n" +
                "No bundled binary for platform '%s/%s' and thrift not in PATH.\n" % (os_name, os_arch) +
                "Please build thrift 0.16.0 from source and place at:\n" +
                "  tools/bin/thrift-0.16.0-%s" % (platform or "<platform>"),
            )
        repository_ctx.symlink(thrift_path, "thrift")

    repository_ctx.file("BUILD.bazel", content = """
package(default_visibility = ["//visibility:public"])
exports_files(["thrift"])
""")

thrift_compiler_repo = repository_rule(
    implementation = _thrift_compiler_repo_impl,
    attrs = {
        "_workspace_root": attr.label(default = "//:MODULE.bazel"),
    },
    local = True,
    environ = ["PATH"],
)
