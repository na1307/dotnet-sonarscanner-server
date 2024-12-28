#!/bin/bash

if [ "$RUNNER_OS" == "Windows" ]; then
    echo "BUILD_SHELL=pwsh" >> $GITHUB_ENV
else
    echo "BUILD_SHELL=bash" >> $GITHUB_ENV
fi
