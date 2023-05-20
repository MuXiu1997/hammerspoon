#!/usr/bin/env just --justfile

[private]
default:
  @just --choose -u

sync:
  rsync -av --delete --include="*.lua" --include="internal_scripts" --include="internal_scripts/*" --exclude='*' ./ ~/.config/hammerspoon
