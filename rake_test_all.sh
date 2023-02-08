#!/bin/bash -ex
RBENV_VERSION=2.6.9 bundle exec rake test
RBENV_VERSION=2.7.6 bundle exec rake test
RBENV_VERSION=3.0.4 bundle exec rake test
RBENV_VERSION=3.1.2 bundle exec rake test
RBENV_VERSION=3.2.0 bundle exec rake test
RBENV_VERSION=3.3.0-dev bundle exec rake test
