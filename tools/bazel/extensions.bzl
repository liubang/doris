"""Module extensions for Doris build tools."""

load("//tools/bazel:deps.bzl", "grpc_java_plugin_repo", "thrift_compiler_repo")

def _doris_tools_impl(module_ctx):
    """Register external tool repositories."""
    thrift_compiler_repo(name = "thrift_compiler")
    grpc_java_plugin_repo(name = "grpc_java_plugin")

doris_tools = module_extension(
    implementation = _doris_tools_impl,
)
