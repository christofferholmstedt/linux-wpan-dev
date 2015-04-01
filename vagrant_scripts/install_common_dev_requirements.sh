#!/bin/bash

##################################################
# Installation of common development packages
##################################################

### Git and Vim
sudo apt-get -y install vim git

### Build tools
sudo apt-get -y install build-essential doxygen \
                        subversion cmake
