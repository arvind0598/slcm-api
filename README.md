# SLCM API

API for SLCM made using Sinatra and Nokogiri.

## Pre setup instructions

If you're using a Ruby build provided by Ubuntu, uninstall it with ```sudo apt remove ruby``` followed by ```sudo apt autoremove```.

Install **rbenv** using the instructions [here](https://github.com/rbenv/rbenv#installation).
Further, install **[ruby-build](https://github.com/rbenv/ruby-build)** as a rbenv plugin.

Install Ruby. This is the latest version as of writing this document.

```bash
rbenv install 2.6.1
rbenv global 2.6.1
gem install bundler
rbenv rehash
```

## Setup Instructions

Install dependencies with ```bundle install```.

Run the script with ```ruby main.rb```