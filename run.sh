#!/usr/bin/env bash

swift build
.build/debug/podunfold $@
