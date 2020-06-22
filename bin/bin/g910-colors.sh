#!/bin/bash
# Simple script to set up LED colors for g910.  May require sudo.
# Uses https://github.com/MatMoul/g810-led.git, which may also be installed
# from apt with `sudo apt-get install g810-led`.

g910-led -a 009600
g910-led -g logo 0096ff
g910-led -g gkeys 0096ff
