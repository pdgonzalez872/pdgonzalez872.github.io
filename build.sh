#!/bin/bash

echo "Start building"
MIX_ENV=prod PHX_HOST=localhost mix assets.deploy && MIX_ENV=prod PHX_HOST=localhost SECRET_KEY_BASE=hi mix build_static

echo "Kill docs dir"
rm -rf docs

echo "Move new dir to docs"
mv build docs

echo "Finish building"
