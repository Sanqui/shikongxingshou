#!/bin/bash
# Compares baserom.gbc and skxs.gbc

# create baserom.txt if necessary
if [ ! -f baserom.txt ]; then
    hexdump -C baserom.gbc > baserom.txt
fi

hexdump -C skxs.gbc > skxs.txt

diff baserom.txt skxs.txt | less
