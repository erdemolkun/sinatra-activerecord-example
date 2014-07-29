require "sinatra/activerecord"
require "./models/post"

class MyApplication < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  
  configure :development do
    set :database, {adapter: "sqlite3", database: "test.sqlite3"}
  end
  
  configure :production do
    db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
    ActiveRecord::Base.establish_connection(
      :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
      :host     => db.host,
      :username => db.user,
      :password => db.password,
      :database => db.path[1..-1],
      :encoding => 'utf8'
    )
  end
  
  get "/" do
    @posts = Post.all
    erb :index
  end
  
  get "/post/:id/" do
    @post = Post.find(params[:id])
    erb :post
  end
end
