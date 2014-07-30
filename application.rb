require "sinatra/activerecord"
require "i18n"
require "i18n/backend/fallbacks"
require "./models/post"

Time.zone = "Istanbul"
ActiveRecord::Base.default_timezone = :local

class MyApplication < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  
  # put, delete etc verbs...
  set :method_override, true
  
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

  helpers do
    def h(html)
      Rack::Utils.escape_html html
    end
    
    def partial(template, locals = {})
      erb "_#{template.to_sym}".to_sym, :layout => false, :locals => locals
    end
  end
  
  get "/" do
    @posts = Post.order(updated_at: :desc).all
    erb :index
  end
  
  post "/post/" do
    @post = Post.new(params[:post])
    if @post.save
      redirect "/post/#{@post.id}/"
    else
      erb :post_new
    end
  end
  
  get "/post/new/" do
    @post = Post.new
    erb :post_new
  end

  get "/post/edit/:id/" do
    @post = Post.find(params[:id])
    erb :post_edit
  end

  get "/post/:id/" do
    @post = Post.find(params[:id])
    erb :post
  end
  
  put "/post/:id/" do
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      redirect "/post/#{@post.id}/"
    else
      erb :post_edit
    end
  end

  delete "/post/:id" do
    @post = Post.find(params[:id]).destroy
    redirect "/"
  end
end
