require "sinatra/activerecord"
require "./models/post"

class MyApplication < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  
  set :database, {adapter: "sqlite3", database: "test.sqlite3"}
  
  get "/" do
    @posts = Post.all
    erb :index
  end
  
  get "/post/:id/" do
    @post = Post.find(params[:id])
    erb :post
  end
end
