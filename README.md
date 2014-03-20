# Welcome to Breakpoint App

Breakpoint App is a free tennis league scheduling web application

## Application details

* based on Ruby on Rails
* distributed under the MIT License

## Requirements

* Ubuntu/Debian (not tested on Windows)
* ruby 2.1.0+ (not tested on 1.9.3+)
* PostgreSQL

## Install

1. Bundle install
* cp config/database.yml.example config/database.yml
* createuser -s -r breakpoint_app
* rake db:setup breakpointapp:reset_passwords breakpointapp:user_info
* Note: the reset_passwords task will set the sample user passwords to 'password' and the user_info task will output a list of valid email addresses to the console
* rails s
* login using a valid email address and password

## Contacts

Twitter:

 * @breakpointapp
 * @davekaro

Email

 * admin@breakpointapp.com

## Contributing

[![Build Status](https://travis-ci.org/davekaro/breakpoint-app.png?branch=master)](https://travis-ci.org/davekaro/breakpoint-app)
[![Code Climate](https://codeclimate.com/github/davekaro/breakpoint-app.png)](https://codeclimate.com/github/davekaro/breakpoint-app)

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request