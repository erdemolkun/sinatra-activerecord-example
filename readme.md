# Sinatra + Activerecord Example

Here is a small example of **sqlite** database using with [sinatra-activerecord][1].
Also, [tux][2] gem for interactive [Sinatra][3] shell!

## Setup

First, install the gems:

    bundle install --path=vendor/bundle --without production

After, create the db `rake db:migrate` then you can add sample seed data with
`rake db:seed`. This will read data from `db/seeds.rb` and fill the db.

You can `rake` to start development server. Also, use `rake tux` for interactive
shell. Like;

    Post.all
    Post.find_by_id(1)

Enjoy!

## Deploy to Heroku

First you need to create Heroku app: `heroku apps:create` then you need to
push it to Heroku : `git push heroku master`. After that you need to run
migration : `heroku run rake db:migrate` after that you need to inject
seed data : `heroku run rake db:seed`.

then `heroku open` to launch you site!

You can set **Time Zone** information via;

`heroku config:add TZ="Europe/Istanbul` # for İstanbul. After this, please
restart your app : `heroku ps:restart web` and re-run seeding `heroku run rake db:seed`

My example app : [http://still-bayou-4809.herokuapp.com](http://still-bayou-4809.herokuapp.com)


[1]: https://github.com/janko-m/sinatra-activerecord
[2]: https://github.com/cldwalker/tux
[3]: http://www.sinatrarb.com/