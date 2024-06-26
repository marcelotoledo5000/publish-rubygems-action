#!/bin/bash

echo "Setting up gem credentials..."
set +x
mkdir -p ~/.gem

cat << EOF > ~/.gem/credentials
---
:rubygems_api_key: ${RUBYGEMS_API_KEY}
EOF

chmod 0600 ~/.gem/credentials
set -x

gem_version=$(ruby -r rubygems -e "puts Gem::Specification::load('$(ls *.gemspec)').version")

if git fetch origin "refs/tags/v$gem_version" >/dev/null 2>&1
then
  echo "Tag 'v$gem_version' already exists"
else
  git config --global --add safe.directory $PWD
  git config user.email "${GIT_EMAIL:-automated@example.com}"
  git config user.name "${GIT_NAME:-Automated Release}"

  echo "Installing dependencies..."
  gem update bundler
  bundle install

  echo "Running gem release task..."
  release_command="${RELEASE_COMMAND:-rake release}"
  exec $release_command
fi
