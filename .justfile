#!/usr/bin/env just --justfile

project_dir := justfile_directory()

[private]
default:
  @just --choose -u

sync:
  rsync -av --delete --include="*.lua" --include="internal_scripts" --include="internal_scripts/*" --exclude='*' {{ project_dir }}/ ~/.config/hammerspoon
