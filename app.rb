require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

configure do
  enable :sessions
end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Hello stranger'
  end
end
get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
	erb :contacts
end

post '/visit' do
	@username, @phone, @datetime, @master = params[:username], params[:phone], params[:datetime], params[:master]
	f = File.open './public/leads.txt', 'a'
	f. write "User: #{@username}, Phone: #{@phone}, Date and time of visit: #{@datetime}, Master: #{@master}\n"
	f.close
	erb :visit
end

post '/contacts' do
	@email, @message = params[:email], params[:message]
	f = File.open './public/contacts.txt', 'a'
	f. write "Email: #{@email}, Message: #{@message}\n"
	f.close
	erb :contacts
end

get '/login/form' do
  erb :login_form
end

post '/login/attempt' do
  @user_name = params[:username]
  @password = params[:psw]
  if @user_name == 'admin' && @password == 'secret'
 	 session[:identity] = params[:username]
	 erb :admin
  else
    @error = 'Sorry, you need to be logged in to visit ' + 'Admin panel'
    halt erb(:login_form)
  end
end

get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Logged out</div>"
end