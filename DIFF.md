## Diff

```diff
diff --git a/DIFF.md b/DIFF.md
new file mode 100644
index 0000000..d0e7215
--- /dev/null
+++ b/DIFF.md
@@ -0,0 +1,211 @@
+## Diff
+
+```diff
+diff --git a/README.md b/README.md
+index f5ce22b..28a4b0f 100644
+--- a/README.md
++++ b/README.md
+@@ -1,38 +1,7 @@
+ <h1 align="center"> dotenv 🌴 </h1>
+
+-This is a fork of dying-will-bullet/dotenv to support Zig 0.14. Specifically, the build.zig has been updated:
+-```
+-diff --git a/build.zig b/build.zig
+-index f874b0a..9ff1aa2 100644
+---- a/build.zig
+-+++ b/build.zig
+-@@ -16,14 +16,14 @@ pub fn build(b: *std.Build) void {
+-     const optimize = b.standardOptimizeOption(.{});
+-
+-     _ = b.addModule("dotenv", .{
+--        .root_source_file = .{ .path = "src/lib.zig" },
+-+        .root_source_file = b.path("src/lib.zig"),
+-     });
++This is a fork of dying-will-bullet/dotenv to support Zig 0.14. The change can be found in DIFF.md.
+
+-     const lib = b.addStaticLibrary(.{
+-         .name = "dotenv",
+-         // In this case the main source file is merely a path, however, in more
+-         // complicated build scripts, this could be a generated file.
+--        .root_source_file = .{ .path = "src/lib.zig" },
+-+        .root_source_file = b.path("src/lib.zig"),
+-         .target = target,
+-         .optimize = optimize,
+-     });
+-@@ -37,7 +37,7 @@ pub fn build(b: *std.Build) void {
+-     // Creates a step for unit testing. This only builds the test executable
+-     // but does not run it.
+-     const main_tests = b.addTest(.{
+--        .root_source_file = .{ .path = "src/lib.zig" },
+-+        .root_source_file = b.path("src/lib.zig"),
+-         .target = target,
+-         .optimize = optimize,
+-     });
+-```
+
+ [![CI](https://github.com/dying-will-bullet/dotenv/actions/workflows/ci.yaml/badge.svg)](https://github.com/dying-will-bullet/dotenv/actions/workflows/ci.yaml)
+ [![codecov](https://codecov.io/gh/dying-will-bullet/dotenv/branch/master/graph/badge.svg?token=D8DHON0VE5)](https://codecov.io/gh/dying-will-bullet/dotenv)
+diff --git a/build.zig b/build.zig
+index 9ff1aa2..9e35b88 100644
+--- a/build.zig
++++ b/build.zig
+@@ -28,6 +28,7 @@ pub fn build(b: *std.Build) void {
+         .optimize = optimize,
+     });
+     lib.linkSystemLibrary("c");
++    lib.linkLibC();
+
+     // This declares intent for the library to be installed into the standard
+     // location when the user invokes the "install" step (the default step when
+diff --git a/src/lib.zig b/src/lib.zig
+index f4b8384..e55979e 100644
+--- a/src/lib.zig
++++ b/src/lib.zig
+@@ -48,36 +48,37 @@ pub fn getDataFrom(allocator: std.mem.Allocator, path: []const u8) !std.StringHa
+ }
+
+ test "test load real file" {
+-    try testing.expect(std.os.getenv("VAR1") == null);
+-    try testing.expect(std.os.getenv("VAR2") == null);
+-    try testing.expect(std.os.getenv("VAR3") == null);
+-    try testing.expect(std.os.getenv("VAR4") == null);
+-    try testing.expect(std.os.getenv("VAR5") == null);
+-    try testing.expect(std.os.getenv("VAR6") == null);
+-    try testing.expect(std.os.getenv("VAR7") == null);
+-    try testing.expect(std.os.getenv("VAR8") == null);
+-    try testing.expect(std.os.getenv("VAR9") == null);
+-    try testing.expect(std.os.getenv("VAR10") == null);
+-    try testing.expect(std.os.getenv("VAR11") == null);
+-    try testing.expect(std.os.getenv("MULTILINE1") == null);
+-    try testing.expect(std.os.getenv("MULTILINE2") == null);
++    // @see https://ziggit.dev/t/os-linux-epoll-create1-compile-error/4029/5
++    try testing.expect(std.posix.getenv("VAR1") == null);
++    try testing.expect(std.posix.getenv("VAR2") == null);
++    try testing.expect(std.posix.getenv("VAR3") == null);
++    try testing.expect(std.posix.getenv("VAR4") == null);
++    try testing.expect(std.posix.getenv("VAR5") == null);
++    try testing.expect(std.posix.getenv("VAR6") == null);
++    try testing.expect(std.posix.getenv("VAR7") == null);
++    try testing.expect(std.posix.getenv("VAR8") == null);
++    try testing.expect(std.posix.getenv("VAR9") == null);
++    try testing.expect(std.posix.getenv("VAR10") == null);
++    try testing.expect(std.posix.getenv("VAR11") == null);
++    try testing.expect(std.posix.getenv("MULTILINE1") == null);
++    try testing.expect(std.posix.getenv("MULTILINE2") == null);
+
+     try loadFrom(testing.allocator, "./testdata/.env", .{});
+
+-    try testing.expectEqualStrings(std.os.getenv("VAR1").?, "hello!");
+-    try testing.expectEqualStrings(std.os.getenv("VAR2").?, "'quotes within quotes'");
+-    try testing.expectEqualStrings(std.os.getenv("VAR3").?, "double quoted with # hash in value");
+-    try testing.expectEqualStrings(std.os.getenv("VAR4").?, "single quoted with # hash in value");
+-    try testing.expectEqualStrings(std.os.getenv("VAR5").?, "not_quoted_with_#_hash_in_value");
+-    try testing.expectEqualStrings(std.os.getenv("VAR6").?, "not_quoted_with_comment_beheind");
+-    try testing.expectEqualStrings(std.os.getenv("VAR7").?, "not quoted with escaped space");
+-    try testing.expectEqualStrings(std.os.getenv("VAR8").?, "double quoted with comment beheind");
+-    try testing.expectEqualStrings(std.os.getenv("VAR9").?, "Variable starts with a whitespace");
+-    try testing.expectEqualStrings(std.os.getenv("VAR10").?, "Value starts with a whitespace after =");
+-    try testing.expectEqualStrings(std.os.getenv("VAR11").?, "Variable ends with a whitespace before =");
+-    try testing.expectEqualStrings(std.os.getenv("MULTILINE1").?, "First Line\nSecond Line");
++    try testing.expectEqualStrings(std.posix.getenv("VAR1").?, "hello!");
++    try testing.expectEqualStrings(std.posix.getenv("VAR2").?, "'quotes within quotes'");
++    try testing.expectEqualStrings(std.posix.getenv("VAR3").?, "double quoted with # hash in value");
++    try testing.expectEqualStrings(std.posix.getenv("VAR4").?, "single quoted with # hash in value");
++    try testing.expectEqualStrings(std.posix.getenv("VAR5").?, "not_quoted_with_#_hash_in_value");
++    try testing.expectEqualStrings(std.posix.getenv("VAR6").?, "not_quoted_with_comment_beheind");
++    try testing.expectEqualStrings(std.posix.getenv("VAR7").?, "not quoted with escaped space");
++    try testing.expectEqualStrings(std.posix.getenv("VAR8").?, "double quoted with comment beheind");
++    try testing.expectEqualStrings(std.posix.getenv("VAR9").?, "Variable starts with a whitespace");
++    try testing.expectEqualStrings(std.posix.getenv("VAR10").?, "Value starts with a whitespace after =");
++    try testing.expectEqualStrings(std.posix.getenv("VAR11").?, "Variable ends with a whitespace before =");
++    try testing.expectEqualStrings(std.posix.getenv("MULTILINE1").?, "First Line\nSecond Line");
+     try testing.expectEqualStrings(
+-        std.os.getenv("MULTILINE2").?,
++        std.posix.getenv("MULTILINE2").?,
+         "# First Line Comment\nSecond Line\n#Third Line Comment\nFourth Line\n",
+     );
+
+diff --git a/src/loader.zig b/src/loader.zig
+index cfec6ec..a2cb097 100644
+--- a/src/loader.zig
++++ b/src/loader.zig
+@@ -263,7 +263,7 @@ test "test load" {
+     try testing.expectEqualStrings(loader.envs().get("KEY8").?.?, "whitespace before =");
+     try testing.expectEqualStrings(loader.envs().get("KEY9").?.?, "whitespace after =");
+
+-    const r = std.os.getenv("KEY0");
++    const r = std.posix.getenv("KEY0");
+     try testing.expectEqualStrings(r.?, "0");
+ }
+
+@@ -297,7 +297,7 @@ test "test not override" {
+     defer loader.deinit();
+     try loader.loadFromStream(reader);
+
+-    const r = std.os.getenv("HOME");
++    const r = std.posix.getenv("HOME");
+     try testing.expect(!std.mem.eql(u8, r.?, "/home/nayuta"));
+ }
+
+@@ -314,7 +314,7 @@ test "test override" {
+     defer loader.deinit();
+     try loader.loadFromStream(reader);
+
+-    const r = std.os.getenv("HOME");
++    const r = std.posix.getenv("HOME");
+     try testing.expect(std.mem.eql(u8, r.?, "/home/nayuta"));
+ }
+
+diff --git a/src/parser.zig b/src/parser.zig
+index 0b2a21d..b039212 100644
+--- a/src/parser.zig
++++ b/src/parser.zig
+@@ -272,7 +272,7 @@ fn substitute_variables(
+     name: []const u8,
+     output: anytype,
+ ) !void {
+-    if (std.os.getenv(name)) |value| {
++    if (std.posix.getenv(name)) |value| {
+         _ = try output.write(value);
+     } else {
+         const value = ctx.get(name) orelse "";
+@@ -315,7 +315,7 @@ test "test parse" {
+     var parser = LineParser.init(allocator);
+     defer parser.deinit();
+
+-    var it = std.mem.split(u8, input, "\n");
++    var it = std.mem.splitSequence(u8, input, "\n");
+     var i: usize = 0;
+     while (it.next()) |line| {
+         var buf = std.ArrayList(u8).init(allocator);
+diff --git a/src/utils.zig b/src/utils.zig
+index 227e338..282b880 100644
+--- a/src/utils.zig
++++ b/src/utils.zig
+@@ -5,13 +5,13 @@ const testing = std.testing;
+ pub extern "c" fn setenv(name: [*:0]const u8, value: [*:0]const u8, overwrite: c_int) c_int;
+
+ // https://github.com/ziglang/zig/wiki/Zig-Newcomer-Programming-FAQs#converting-from-t-to-0t
+-pub fn toCString(str: []const u8) ![std.fs.MAX_PATH_BYTES - 1:0]u8 {
++pub fn toCString(str: []const u8) ![std.fs.max_path_bytes - 1:0]u8 {
+     if (std.debug.runtime_safety) {
+         std.debug.assert(std.mem.indexOfScalar(u8, str, 0) == null);
+     }
+-    var path_with_null: [std.fs.MAX_PATH_BYTES - 1:0]u8 = undefined;
++    var path_with_null: [std.fs.max_path_bytes - 1:0]u8 = undefined;
+
+-    if (str.len >= std.fs.MAX_PATH_BYTES) {
++    if (str.len >= std.fs.max_path_bytes) {
+         return error.NameTooLong;
+     }
+     @memcpy(path_with_null[0..str.len], str);
+@@ -43,7 +43,7 @@ pub const FileFinder = struct {
+     /// The return value should be freed by caller.
+     pub fn find(self: Self, allocator: std.mem.Allocator) ![]const u8 {
+         // TODO: allocator?
+-        var buf: [std.fs.MAX_PATH_BYTES]u8 = undefined;
++        var buf: [std.fs.max_path_bytes]u8 = undefined;
+         const cwd = try std.process.getCwd(&buf);
+
+         const path = try Self.recursiveFind(allocator, cwd, self.filename);
+```
diff --git a/README.md b/README.md
index 30d1319..aecbc01 100644
--- a/README.md
+++ b/README.md
@@ -1,5 +1,7 @@
 <h1 align="center"> dotenv 🌴 </h1>

+This is a fork of dying-will-bullet/dotenv to support Zig 0.14. The change can be found in DIFF.md.
+
 [![CI](https://github.com/dying-will-bullet/dotenv/actions/workflows/ci.yaml/badge.svg)](https://github.com/dying-will-bullet/dotenv/actions/workflows/ci.yaml)
 [![codecov](https://codecov.io/gh/dying-will-bullet/dotenv/branch/master/graph/badge.svg?token=D8DHON0VE5)](https://codecov.io/gh/dying-will-bullet/dotenv)
 ![](https://img.shields.io/badge/language-zig-%23ec915c)
@@ -10,8 +12,6 @@ Storing configuration in the environment separate from code is based on The

 This library is a Zig language port of [nodejs dotenv](https://github.com/motdotla/dotenv).

-Test with Zig 0.12.0-dev.1664+8ca4a5240.
-
 ## Quick Start

 Automatically find the `.env` file and load the variables into the process environment with just one line.
@@ -36,7 +36,7 @@ pub fn main() !void {
 }
 ```

-**Since writing to `std.os.environ` requires a C `setenv` call, linking with C is necessary.**
+**Since writing to `std.posix.environ` requires a C `setenv` call, linking with C is necessary.**

 If you only want to read and parse the contents of the `.env` file, you can try the following.

@@ -105,8 +105,8 @@ Add `dotenv` as dependency in `build.zig.zon`:
     .version = "0.1.0",
     .dependencies = .{
        .dotenv = .{
-           .url = "https://github.com/dying-will-bullet/dotenv/archive/refs/tags/v0.1.1.tar.gz",
-           .hash = "1220f0f6736020856641d3644ef44f95ce21f3923d5dae7f9ac8658187574d36bcb8"
+           .url = "https://github.com/edwardwc/dotenv/archive/refs/tags/v0.0.42.tar.gz",
+           .hash = "1220e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
        },
     },
     .paths = .{""}
diff --git a/build.zig b/build.zig
index f874b0a..9ff1aa2 100644
--- a/build.zig
+++ b/build.zig
@@ -16,14 +16,14 @@ pub fn build(b: *std.Build) void {
     const optimize = b.standardOptimizeOption(.{});

     _ = b.addModule("dotenv", .{
-        .root_source_file = .{ .path = "src/lib.zig" },
+        .root_source_file = b.path("src/lib.zig"),
     });

     const lib = b.addStaticLibrary(.{
         .name = "dotenv",
         // In this case the main source file is merely a path, however, in more
         // complicated build scripts, this could be a generated file.
-        .root_source_file = .{ .path = "src/lib.zig" },
+        .root_source_file = b.path("src/lib.zig"),
         .target = target,
         .optimize = optimize,
     });
@@ -37,7 +37,7 @@ pub fn build(b: *std.Build) void {
     // Creates a step for unit testing. This only builds the test executable
     // but does not run it.
     const main_tests = b.addTest(.{
-        .root_source_file = .{ .path = "src/lib.zig" },
+        .root_source_file = b.path("src/lib.zig"),
         .target = target,
         .optimize = optimize,
     });
diff --git a/build.zig.zon b/build.zig.zon
new file mode 100644
index 0000000..f048417
--- /dev/null
+++ b/build.zig.zon
@@ -0,0 +1,73 @@
+.{
+    // This is the default name used by packages depending on this one. For
+    // example, when a user runs `zig fetch --save <url>`, this field is used
+    // as the key in the `dependencies` table. Although the user can choose a
+    // different name, most users will stick with this provided value.
+    //
+    // It is redundant to include "zig" in this name because it is already
+    // within the Zig package namespace.
+    .name = "dotenv",
+
+    // This is a [Semantic Version](https://semver.org/).
+    // In a future version of Zig it will be used for package deduplication.
+    .version = "0.0.42",
+
+    // This field is optional.
+    // This is currently advisory only; Zig does not yet do anything
+    // with this value.
+    //.minimum_zig_version = "0.11.0",
+
+    // This field is optional.
+    // Each dependency must either provide a `url` and `hash`, or a `path`.
+    // `zig build --fetch` can be used to fetch all dependencies of a package, recursively.
+    // Once all dependencies are fetched, `zig build` no longer requires
+    // internet connectivity.
+    .dependencies = .{
+        // See `zig fetch --save <url>` for a command-line interface for adding dependencies.
+        //.example = .{
+        //    // When updating this field to a new URL, be sure to delete the corresponding
+        //    // `hash`, otherwise you are communicating that you expect to find the old hash at
+        //    // the new URL.
+        //    .url = "https://example.com/foo.tar.gz",
+        //
+        //    // This is computed from the file contents of the directory of files that is
+        //    // obtained after fetching `url` and applying the inclusion rules given by
+        //    // `paths`.
+        //    //
+        //    // This field is the source of truth; packages do not come from a `url`; they
+        //    // come from a `hash`. `url` is just one of many possible mirrors for how to
+        //    // obtain a package matching this `hash`.
+        //    //
+        //    // Uses the [multihash](https://multiformats.io/multihash/) format.
+        //    .hash = "...",
+        //
+        //    // When this is provided, the package is found in a directory relative to the
+        //    // build root. In this case the package's hash is irrelevant and therefore not
+        //    // computed. This field and `url` are mutually exclusive.
+        //    .path = "foo",
+        //
+        //    // When this is set to `true`, a package is declared to be lazily
+        //    // fetched. This makes the dependency only get fetched if it is
+        //    // actually used.
+        //    .lazy = false,
+        //},
+    },
+
+    // Specifies the set of files and directories that are included in this package.
+    // Only files and directories listed here are included in the `hash` that
+    // is computed for this package. Only files listed here will remain on disk
+    // when using the zig package manager. As a rule of thumb, one should list
+    // files required for compilation plus any license(s).
+    // Paths are relative to the build root. Use the empty string (`""`) to refer to
+    // the build root itself.
+    // A directory listed here means that all files within, recursively, are included.
+    .paths = .{
+        "build.zig",
+        "build.zig.zon",
+        "src",
+        "examples",
+        "testdata",
+        "LICENSE",
+        "README.md",
+    },
+}
diff --git a/scripts/hash.sh b/scripts/hash.sh
new file mode 100755
index 0000000..988e402
--- /dev/null
+++ b/scripts/hash.sh
@@ -0,0 +1,68 @@
+#!/usr/bin/env sh
+
+# credit to:
+# @see https://gist.github.com/michalsieron/a07da4216d6c5e69b32f2993c61af1b7
+# @see https://zig.news/michalsieron/buildzigzon-dependency-hashes-47kj
+
+# Usage: zig-hash <path to build.zig.zon>
+BUILD_ZIG_ZON="${1:-build.zig.zon}"
+ROOT_DIR="$(dirname "$BUILD_ZIG_ZON")"
+
+# Get hash of a file, which is computed from:
+# - its normalized filepath
+# - followed by two null bytes (apparently temporary solution in Zig, only for normal files)
+# - followed by actual file content
+hashFile() {
+    filepath="$1"
+    normalized="$(realpath --relative-to="$ROOT_DIR" "$filepath")"
+
+    printf "%s:" "$filepath"
+
+    if [ -f "$filepath" ] && [ -r "$filepath" ]; then
+        (printf "%s\0\0" "$normalized"; cat "$filepath") | sha256sum | cut -d' ' -f1
+    elif [ -h "$filepath" ]; then
+        (printf "%s" "$normalized"; readlink -n "$filepath") | sha256sum | cut -d' ' -f1
+    else
+        printf "\r%s: is not a file, not a symlink, doesn't exist or isn't readable!\n" "$filepath" >&2
+        exit 1
+    fi
+}
+
+# Convert all incoming pairs or <filepath>:<hash> to a string
+# of hash bytes, concatenate and hash again
+combineHashes() {
+    cut -d ':'  -f2 | xxd -r -p | sha256sum | cut -d' ' -f1
+}
+
+# List all files and symlinks that are part of the package:
+# 1. Remove all comments
+# 2. Remove all whitespace with `tr` to concatenate all lines
+# 3. Extract content from `.paths=.{<content>}`
+# 4. Replace all `","` with new lines
+# 5. Remove initial quote (`"`) and trailing quote (`"`) with optional comma (`,`)
+# 6. Prepend each line with $ROOT_DIR
+# 7. Replace new lines with null bytes
+# 8. Find all files and symlinks using content from earlier as starting points
+# 9. Sort by filename
+packageContent() {
+    # shellcheck disable=SC2002
+    # shellcheck disable=SC2185
+    cat "${1}" \
+        | sed 's|//.*||' \
+        | tr -d '[:space:]' \
+        | sed -E 's/.*\.paths=\.\{([^}]*)\}.*/\1/' \
+        | sed 's/","/\n/g' \
+        | sed -E -e 's/^"//; s/",?$/\n/' \
+        | sed "s|^|$ROOT_DIR/|g" \
+        | tr '\n' '\0' \
+        | find -files0-from - -type f -or -type l 2>/dev/null \
+        | LC_ALL=C sort
+}
+
+# 12 stands for sha256 and 20 is hash length in hex (32 in decimal)
+printf "1220"
+
+packageContent "$BUILD_ZIG_ZON" \
+    | while read -r filepath; do
+    hashFile "$filepath"
+done | combineHashes
diff --git a/scripts/release.sh b/scripts/release.sh
new file mode 100755
index 0000000..35cc891
--- /dev/null
+++ b/scripts/release.sh
@@ -0,0 +1,14 @@
+#!/bin/bash
+
+set -eux
+
+VERSION=$1
+
+zig build test
+zig build
+
+zip -r dotenv-$VERSION.zip src/ zig-out/
+echo "Created dotenv-$VERSION.zip"
+
+tar -czvf dotenv-$VERSION.tar.gz src/ zig-out/
+echo "Created dotenv-$VERSION.tar.gz"
diff --git a/src/lib.zig b/src/lib.zig
index f4b8384..e55979e 100644
--- a/src/lib.zig
+++ b/src/lib.zig
@@ -48,36 +48,37 @@ pub fn getDataFrom(allocator: std.mem.Allocator, path: []const u8) !std.StringHa
 }

 test "test load real file" {
-    try testing.expect(std.os.getenv("VAR1") == null);
-    try testing.expect(std.os.getenv("VAR2") == null);
-    try testing.expect(std.os.getenv("VAR3") == null);
-    try testing.expect(std.os.getenv("VAR4") == null);
-    try testing.expect(std.os.getenv("VAR5") == null);
-    try testing.expect(std.os.getenv("VAR6") == null);
-    try testing.expect(std.os.getenv("VAR7") == null);
-    try testing.expect(std.os.getenv("VAR8") == null);
-    try testing.expect(std.os.getenv("VAR9") == null);
-    try testing.expect(std.os.getenv("VAR10") == null);
-    try testing.expect(std.os.getenv("VAR11") == null);
-    try testing.expect(std.os.getenv("MULTILINE1") == null);
-    try testing.expect(std.os.getenv("MULTILINE2") == null);
+    // @see https://ziggit.dev/t/os-linux-epoll-create1-compile-error/4029/5
+    try testing.expect(std.posix.getenv("VAR1") == null);
+    try testing.expect(std.posix.getenv("VAR2") == null);
+    try testing.expect(std.posix.getenv("VAR3") == null);
+    try testing.expect(std.posix.getenv("VAR4") == null);
+    try testing.expect(std.posix.getenv("VAR5") == null);
+    try testing.expect(std.posix.getenv("VAR6") == null);
+    try testing.expect(std.posix.getenv("VAR7") == null);
+    try testing.expect(std.posix.getenv("VAR8") == null);
+    try testing.expect(std.posix.getenv("VAR9") == null);
+    try testing.expect(std.posix.getenv("VAR10") == null);
+    try testing.expect(std.posix.getenv("VAR11") == null);
+    try testing.expect(std.posix.getenv("MULTILINE1") == null);
+    try testing.expect(std.posix.getenv("MULTILINE2") == null);

     try loadFrom(testing.allocator, "./testdata/.env", .{});

-    try testing.expectEqualStrings(std.os.getenv("VAR1").?, "hello!");
-    try testing.expectEqualStrings(std.os.getenv("VAR2").?, "'quotes within quotes'");
-    try testing.expectEqualStrings(std.os.getenv("VAR3").?, "double quoted with # hash in value");
-    try testing.expectEqualStrings(std.os.getenv("VAR4").?, "single quoted with # hash in value");
-    try testing.expectEqualStrings(std.os.getenv("VAR5").?, "not_quoted_with_#_hash_in_value");
-    try testing.expectEqualStrings(std.os.getenv("VAR6").?, "not_quoted_with_comment_beheind");
-    try testing.expectEqualStrings(std.os.getenv("VAR7").?, "not quoted with escaped space");
-    try testing.expectEqualStrings(std.os.getenv("VAR8").?, "double quoted with comment beheind");
-    try testing.expectEqualStrings(std.os.getenv("VAR9").?, "Variable starts with a whitespace");
-    try testing.expectEqualStrings(std.os.getenv("VAR10").?, "Value starts with a whitespace after =");
-    try testing.expectEqualStrings(std.os.getenv("VAR11").?, "Variable ends with a whitespace before =");
-    try testing.expectEqualStrings(std.os.getenv("MULTILINE1").?, "First Line\nSecond Line");
+    try testing.expectEqualStrings(std.posix.getenv("VAR1").?, "hello!");
+    try testing.expectEqualStrings(std.posix.getenv("VAR2").?, "'quotes within quotes'");
+    try testing.expectEqualStrings(std.posix.getenv("VAR3").?, "double quoted with # hash in value");
+    try testing.expectEqualStrings(std.posix.getenv("VAR4").?, "single quoted with # hash in value");
+    try testing.expectEqualStrings(std.posix.getenv("VAR5").?, "not_quoted_with_#_hash_in_value");
+    try testing.expectEqualStrings(std.posix.getenv("VAR6").?, "not_quoted_with_comment_beheind");
+    try testing.expectEqualStrings(std.posix.getenv("VAR7").?, "not quoted with escaped space");
+    try testing.expectEqualStrings(std.posix.getenv("VAR8").?, "double quoted with comment beheind");
+    try testing.expectEqualStrings(std.posix.getenv("VAR9").?, "Variable starts with a whitespace");
+    try testing.expectEqualStrings(std.posix.getenv("VAR10").?, "Value starts with a whitespace after =");
+    try testing.expectEqualStrings(std.posix.getenv("VAR11").?, "Variable ends with a whitespace before =");
+    try testing.expectEqualStrings(std.posix.getenv("MULTILINE1").?, "First Line\nSecond Line");
     try testing.expectEqualStrings(
-        std.os.getenv("MULTILINE2").?,
+        std.posix.getenv("MULTILINE2").?,
         "# First Line Comment\nSecond Line\n#Third Line Comment\nFourth Line\n",
     );

diff --git a/src/loader.zig b/src/loader.zig
index cfec6ec..a2cb097 100644
--- a/src/loader.zig
+++ b/src/loader.zig
@@ -263,7 +263,7 @@ test "test load" {
     try testing.expectEqualStrings(loader.envs().get("KEY8").?.?, "whitespace before =");
     try testing.expectEqualStrings(loader.envs().get("KEY9").?.?, "whitespace after =");

-    const r = std.os.getenv("KEY0");
+    const r = std.posix.getenv("KEY0");
     try testing.expectEqualStrings(r.?, "0");
 }

@@ -297,7 +297,7 @@ test "test not override" {
     defer loader.deinit();
     try loader.loadFromStream(reader);

-    const r = std.os.getenv("HOME");
+    const r = std.posix.getenv("HOME");
     try testing.expect(!std.mem.eql(u8, r.?, "/home/nayuta"));
 }

@@ -314,7 +314,7 @@ test "test override" {
     defer loader.deinit();
     try loader.loadFromStream(reader);

-    const r = std.os.getenv("HOME");
+    const r = std.posix.getenv("HOME");
     try testing.expect(std.mem.eql(u8, r.?, "/home/nayuta"));
 }

diff --git a/src/parser.zig b/src/parser.zig
index 0b2a21d..b039212 100644
--- a/src/parser.zig
+++ b/src/parser.zig
@@ -272,7 +272,7 @@ fn substitute_variables(
     name: []const u8,
     output: anytype,
 ) !void {
-    if (std.os.getenv(name)) |value| {
+    if (std.posix.getenv(name)) |value| {
         _ = try output.write(value);
     } else {
         const value = ctx.get(name) orelse "";
@@ -315,7 +315,7 @@ test "test parse" {
     var parser = LineParser.init(allocator);
     defer parser.deinit();

-    var it = std.mem.split(u8, input, "\n");
+    var it = std.mem.splitSequence(u8, input, "\n");
     var i: usize = 0;
     while (it.next()) |line| {
         var buf = std.ArrayList(u8).init(allocator);
diff --git a/src/utils.zig b/src/utils.zig
index 227e338..282b880 100644
--- a/src/utils.zig
+++ b/src/utils.zig
@@ -5,13 +5,13 @@ const testing = std.testing;
 pub extern "c" fn setenv(name: [*:0]const u8, value: [*:0]const u8, overwrite: c_int) c_int;

 // https://github.com/ziglang/zig/wiki/Zig-Newcomer-Programming-FAQs#converting-from-t-to-0t
-pub fn toCString(str: []const u8) ![std.fs.MAX_PATH_BYTES - 1:0]u8 {
+pub fn toCString(str: []const u8) ![std.fs.max_path_bytes - 1:0]u8 {
     if (std.debug.runtime_safety) {
         std.debug.assert(std.mem.indexOfScalar(u8, str, 0) == null);
     }
-    var path_with_null: [std.fs.MAX_PATH_BYTES - 1:0]u8 = undefined;
+    var path_with_null: [std.fs.max_path_bytes - 1:0]u8 = undefined;

-    if (str.len >= std.fs.MAX_PATH_BYTES) {
+    if (str.len >= std.fs.max_path_bytes) {
         return error.NameTooLong;
     }
     @memcpy(path_with_null[0..str.len], str);
@@ -43,7 +43,7 @@ pub const FileFinder = struct {
     /// The return value should be freed by caller.
     pub fn find(self: Self, allocator: std.mem.Allocator) ![]const u8 {
         // TODO: allocator?
-        var buf: [std.fs.MAX_PATH_BYTES]u8 = undefined;
+        var buf: [std.fs.max_path_bytes]u8 = undefined;
         const cwd = try std.process.getCwd(&buf);

         const path = try Self.recursiveFind(allocator, cwd, self.filename);
```
