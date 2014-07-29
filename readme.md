# Sinatra + Activerecord Example

Here is a small example of **sqlite** database using with [sinatra-activerecord][1].
Also, [tux][2] gem for interactive [Sinatra][3] shell!

## Setup

First, install the gems:

    bundle install --path=vendor/bundle

After, create the db `rake db:migrate` then you can add sample seed data with
`rake db:seed`. This will read data from `db/seeds.rb` and fill the db.

You can `rake` to start development server. Also, use `rake tux` for interactive
shell. Like;

    Post.all
    Post.find_by_id(1)

Enjoy!


[1]: https://github.com/janko-m/sinatra-activerecord
[2]: https://github.com/cldwalker/tux
[3]: http://www.sinatrarb.com/