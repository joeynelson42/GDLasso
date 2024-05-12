#!/bin/bash

echo "Starting Build Script"

echo "Quitting Godot"
osascript -e 'quit app "Godot"'

sleep .5

echo "Building Extension"
cd GDLassoExample/
swift build --configuration debug
cd ..

echo "Copying Extension"
cp GDLassoExample/.build/arm64-apple-macosx/debug/libGDLassoExample.dylib Example/bin/libGDLassoExample.dylib

sleep .5

echo "Opening Godot"
open Example/project.godot

echo "Finished Build Script"
