# Package

version = "0.5.0"
author = "Dmitry Matveyev"
description = "The Ultimate Raylib gaming library wrapper"
license = "MIT"
srcDir = "src"
skipFiles = @["converter.nim"]
backend = "c"

# Dependencies

requires "nim >= 1.4.2"
requires "regex"

task convert, "run with c2nim":
  echo "Running converter\n"
  exec "nim r src/converter.nim"
  echo "\nExecuting nim check\n"
  exec "nim check src/nimraylib_now/raylib.nim"
  exec "nim check src/nimraylib_now/raygui.nim"
  exec "nim check src/nimraylib_now/rlgl.nim"
  exec "nim check src/nimraylib_now/raymath.nim"

task buildRaygui, "build raygui as a dynamic library":
  exec "cc -x c -fPIC -c -o raygui.o -DRAYGUI_IMPLEMENTATION -DRAYGUI_SUPPORT_ICONS raygui/src/raygui.h"
  exec "cc -shared -o libraygui.so -lraylib raygui.o"
  rmFile "raygui.o"

task testExamples, "checks that all examples are correctly compiled":
  exec "testament p 'tests/examples/**/*.nim'"
