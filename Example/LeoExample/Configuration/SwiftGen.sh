#!/bin/sh

$PODS_ROOT/SwiftGen/bin/swiftgen strings "$PROJECT_DIR/$PROJECT_NAME/Resources/Localizable.strings" --output "$PROJECT_DIR/$PROJECT_NAME/Constants/Strings.swift" -t structured-swift4
