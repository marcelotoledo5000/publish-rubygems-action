# GitHub Action - Publish Gem to Rubygems

This is a GitHub Action written to streamline the Ruby gem publication process. The action sets the Gem Credentials using `RUBYGEMS_API_KEY` secret and then runs `rake release` in your project root. You can override this command by setting `RELEASE_COMMAND` environment variable to the script that creates and publishes (this is usually only the case when a repository hosts multiple gems together).

# Secrets Needed

`RUBYGEMS_API_KEY` - The Rubygems API Key for an Owner of the Gem you wish to publish. You can find your API Key by looking in `~/.gem/credentials` or using the [Rubygems API](https://guides.rubygems.org/rubygems-org-api/#misc-methods).

# Environment Variables

`RELEASE_COMMAND` - By default, this will invoke `bundle exec rake release` to build and publish the gem to Rubygems. Set this environment variable if you have a custom release command to be invoked.

`GIT_EMAIL`/`GIT_NAME` - A git identity you wish the tags to by published by.

# Example

``` yaml
name: CI

on:
  push:
    branches:
      - master

jobs:
  build:
    runs-on: ubuntu-latest

    steps: (your tests go here)

  publish:
    if: github.event_name == 'push' && github.ref == 'refs/heads/master'
    needs: build
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v2

      - name: Release Gem
        uses: marcelotoledo5000/publish-rubygems-action@master
        env:
          RUBYGEMS_API_KEY: ${{ secrets.RUBYGEMS_API_KEY }}
          RELEASE_COMMAND: bundle exec rake release
          GIT_EMAIL: ci@example.com
          GIT_NAME: Your CI
```
