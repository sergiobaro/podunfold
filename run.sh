#!/usr/bin/env bash

swiftlint lint 2>/dev/null || exit 1

swift build || exit 1
.build/debug/podunfold $@
