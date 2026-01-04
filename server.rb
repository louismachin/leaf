require 'sinatra'
require 'yaml'

require_relative './models/leaf'
require_relative './models/branch'
require_relative './models/tree'
require_relative './models/forest'

require './session.rb'
require './routes.rb'

$forest = Forest.new

PORT = '4545'
APP_ROOT = File.expand_path('.', __dir__)

if File.file?('config.yml')
    $config = YAML.load_file('config.yml')
else
    puts "Missing \"config.yml\"..."
    exit(1)
end

not_found do
    erb :not_found
end

configure do
    set :bind, '0.0.0.0'
    set :port, PORT
    set :public_folder, File.join(APP_ROOT, 'public')
    set :views, File.join(APP_ROOT, 'views')
    set :environment, :production
    disable :protection
end