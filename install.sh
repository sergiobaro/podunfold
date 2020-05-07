#!/usr/bin/env bash

swift build -c release
cp .build/release/podunfold /usr/local/bin/podunfold