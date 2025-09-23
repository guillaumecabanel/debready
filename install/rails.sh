#!/bin/bash

set -e

mise install ruby
mise use --global
mise x ruby -- gem install -N bundler rails mailcatcher
