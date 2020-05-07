#!/usr/bin/env bash

swift build -c release || exit 1
cp .build/release/podunfold /usr/local/bin/podunfold