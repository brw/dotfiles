#!/bin/sh
find . -type l -printf '%P\n' > .gitignore
