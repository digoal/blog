#!/bin/bash

for file in `ls [0-9]*.md` ; do sed -i 's/](2/](..\/2/' $file; done
