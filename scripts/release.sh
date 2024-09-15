#!/bin/bash

set -eux

VERSION=$1

zig build test
zig build

zip -r dotenv-$VERSION.zip src/ zig-out/ build.zig.zon
echo "Created dotenv-$VERSION.zip"

tar -czvf dotenv-$VERSION.tar.gz src/ zig-out/ build.zig.zon
echo "Created dotenv-$VERSION.tar.gz"
