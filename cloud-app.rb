require 'sinatra'
require 'dotenv'
require 'google_drive'
require 'pry'

configure do
	Dotenv.load
	enable :sessions
end

get '/' do
	if session[:user_session]
		@results = session[:user_session].files
		erb :files
	else
		erb :home
	end
end

get '/logout' do
	session.clear
	redirect url('/')
end

get '/sign' do
	credentials = Google::Auth::UserRefreshCredentials.new(
	 client_id: ENV['GOOGLE_CLIENT_ID'],
	 client_secret: ENV['GOOGLE_CLIENT_SECRET'],
	 scope: [
	   "https://www.googleapis.com/auth/drive",
	   "https://spreadsheets.google.com/feeds/",
	 ],
	 redirect_uri: "http://localhost:4567/signed")
	auth_url = credentials.authorization_uri
	redirect auth_url
end

get '/signed' do
	credentials = Google::Auth::UserRefreshCredentials.new(
	 client_id: ENV['GOOGLE_CLIENT_ID'],
	 client_secret: ENV['GOOGLE_CLIENT_SECRET'],
	 scope: [
	   "https://www.googleapis.com/auth/drive",
	   "https://spreadsheets.google.com/feeds/",
	 ],
	 redirect_uri: "http://localhost:4567/signed")
	credentials.code = params[:code]
	credentials.fetch_access_token!
	session[:user_session] = GoogleDrive::Session.from_credentials(credentials)
	redirect url('/')
end