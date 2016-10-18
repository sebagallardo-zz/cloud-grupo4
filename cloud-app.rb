require 'sinatra'
require 'dotenv'

configure do
	Dotenv.load
end

get '/' do
  erb :home
end

get '/sign' do
	credentials = Google::Auth::UserRefreshCredentials.new(
	 client_id: ENV['GOOGLE_CLIENT_ID'],
	 client_secret: ENV['GOOGLE_CLIENT_SECRET'],
	 scope: [
	   "https://www.googleapis.com/auth/drive",
	   "https://spreadsheets.google.com/feeds/",
	 ],
	 redirect_uri: "/signed")
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
	 ])
	credentials.code = params[:authorization_code]
	credentials.fetch_access_token!
	session = GoogleDrive::Session.from_credentials(credentials)
	files = session.files
	binding.pry
	session.files do |file|
	  p file
	end
end