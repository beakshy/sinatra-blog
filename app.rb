require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'digest'
require 'haml'
require 'sinatra-authentication'

# Setup Database
DataMapper.setup(:default, ENV['localhost'] || "sqlite3://#{Dir.pwd}/dev.db")
# DataMapper.setup(:default, "mysql://root:password@localhost/my_db")

# Define Data Properties
class Article
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :content, Text
  property :timestamp, DateTime
  property :meta_description , String , :length => 255
  property :meta_keywords , String , :length => 255
end

DataMapper.finalize.auto_upgrade!

# Define Session Key
use Rack::Session::Cookie, :secret => '1234567890!@#$%ASDFGHJKLZXCVBNMQWERTYUIPOghjklop'

configure do 
    set :sinatra_authentication_view_path, Pathname(__FILE__).dirname.expand_path + "views/account"
    set :logging, true
    enable :sessions
end

# Define helpers
helpers do
 def truncate(text, length, end_string = '...')
  words = text.split()
  words = words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
  end
  def timestamp(time)
   time.strftime("%b %d %Y")
  end
  def title 
    if @title 
     "#{@title}"
    else
     "Thoughts of just another geek"
    end
  end
  def meta_description 
    if @title 
     "#{@meta_description}"
    else
      "Thoughts of just another geek"
    end
  end
  def meta_keywords 
    if @title 
     "#{@meta_keywords}"
    else
      # output nothing
    end
  end
end


#############################
# Public Facing Routes
#############################

get '/' do
  @articles = Article.all(:order => [ :timestamp.desc ], :limit => 20)
  erb :index
end

get '/articles/:id' do |id|
  @article = Article.get!(id)
  @title = @article.title
  @meta_description = @article.meta_description
  @meta_keywords = @article.meta_keywords
  erb :'articles/show'
end


#############################
# Auth Routes
#############################

get '/account' do
    if current_user && current_user.admin?
     haml "= render_login_logout", :layout => :layout
  else
     redirect "/"
  end
end


#############################
# Admin Panel Routes
#############################

get '/admin' do
  if current_user && current_user.admin?
     @articles = Article.all(:order => [ :timestamp.desc ])
     erb :'admin/index'
  else
     redirect "/"
  end
end

get '/admin/new' do
  erb :'admin/new'
end

get '/admin/:id' do |id|
  @article = Article.get!(id)
  erb :'admin/show'
end

get '/admin/:id/edit' do |id|
  @article = Article.get!(id)
  erb :'admin/edit'
end

post '/admin' do
  article = Article.new(params[:article])
  
  if article.save
    redirect '/'
  else
    redirect '/articles/new'
  end
end

put '/admin/:id' do |id|
  article = Article.get!(id)
  success = article.update!(params[:article])
  
  if success
    redirect "/articles/#{id}"
  else
    redirect "/articles/#{id}/edit"
  end
end

delete '/admin/:id' do |id|
  article = Article.get!(id)
  article.destroy!
  redirect "/admin"
end

