class ApplicationController < Sinatra::Base
  require 'bundler'
  Bundler.require()


  #enable sessions
  enable :sessions

  # set up our DB connection --
  ActiveRecord::Base.establish_connection(
    :adapter => 'postgresql',
    :database => 'one_stop'
  )

  # use some Rack Middle to allow us to process patch/delete/put request
  use Rack::MethodOverride

  set :Method_Override, true

  #teach it how to find  templates
  set :views, File.expand_path('../../views', __FILE__)

  # teach it how to find static assets
  set :public_dir, File.expand_path('../../public', __FILE__)


  get '/' do
    #render a splash page of home page
    erb :index
  end

  get '/test' do
    some_text = "this is test"
    binding.pry
   "pry has finished -- here's some_text #{some_text}"
  end

  get '*' do
    
    halt 404
  end

end