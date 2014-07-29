require "sinatra/activerecord"
require "i18n"
require "i18n/backend/fallbacks"
require "./models/post"

Time.zone = "Istanbul"
ActiveRecord::Base.default_timezone = :local

class MyApplication < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  
  configure do
    I18n.enforce_available_locales = false
    I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
    I18n.load_path = Dir[File.join(settings.root, 'locales', '*.yml')]
    I18n.backend.load_translations
    I18n.locale = :tr
  end
  
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
