require 'sinatra/base'
require 'data_mapper'
require 'rack-flash'

env = ENV['RACK_ENV'] || 'development'
DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

require './lib/link'
require './lib/tag'
require './lib/user'
# require_relative 'helper/application'
require_relative 'data_mapper_setup'

DataMapper.finalize
DataMapper.auto_upgrade!

class Bookmark < Sinatra::Base

set :views, Proc.new{ File.join(root,"views") }
set :public, Proc.new{ File.join(root, "public") }
enable :sessions
set :session_secret, 'my unique encryption key!'
use Rack::Flash

  get '/' do
  	@links = Link.all
 		erb :index
  end

  post '/links' do
  	url = params['url']
  	title = params['title']
  	tags = params["tags"].split(" ").map{|tag| Tag.first_or_create(:text => tag)}
  	Link.create(:url => url, :title => title, :tags => tags)
  	redirect to('/')
  end

  get '/tags/:text' do
  	tag = Tag.first(:text => params[:text])
  	@links = tag ? tag.links : []
  	erb :index
  end

  get '/users/new' do
  	@user = User.new
  	erb :"users/new"
  end

  post '/users' do
  	@user = User.new(:email => params[:email],
  							:password => params[:password],
  							:password_confirmation => params[:password_confirmation])
  	if @user.save
  		session[:user_id] = @user.id
  		redirect to('/')
  	else
  		flash[:errors] = @user.errors.full_messages
  		erb :"users/new"
  	end
  end


get '/sessions/new' do
	erb :"sessions/new"
end

post '/sessions' do
	email, password = params[:email], params[:password]
	@user = User.authenticate(email, password)
	if @user
		session[:user_id] = @user_id
		redirect to ('/')
	else
		flash[:errors] = ["The email or password is incorrect"]
		erb :"sessions/new"
	end
end


 def current_user    
    @current_user ||= User.get(session[:user_id]) if session[:user_id]
 end






  # start the server if ruby file executed directly
  run! if app_file == $0
end
