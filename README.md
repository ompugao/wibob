
Wibob -- WIki Based On Bookmark
==========================
Web App Template.

* Ruby 1.8.7+
* Sinatra 1.3+
* Haml
* sass(scss)
* jQuery


I create Wibob from [sinatra-template](https://github.com/shokai/sinatra-templeate). Thanks, shokai.

Install Dependencies
--------------------

    % gem install bundler foreman
    % bundle install --path vendor/bundle

Or, if you use rvm and want to use rvm gemset...

    % rvm gemset create wibob
    % rvm gemset use wibob
    % (rvmsudo) bundle install --system

And then, please install pandoc to your system.
If your machine is debian/ubuntu,

    % sudo aptitude install pandoc

Config
------

    % cp sample.config.yml config.yml

edit it.


Run
---

    % foreman start

open http://localhost:5000

If you don't want to restart server, use shotgun.
    
    % shotgun config.ru


Deploy
------
use Passenger with "config.ru"


LICENSE
=======
(The MIT License)

Copyright (c) 2012 Shohei Fujii

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
