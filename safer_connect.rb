class SaferConnect < Sinatra::Base

  enable :sessions, :logging
  set :logging, true
  set :root, File.dirname(__FILE__)

  get '/' do
    "Hello World"
  end

end
