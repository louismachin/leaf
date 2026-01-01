require 'sinatra'

require_relative './models/leaf'
require_relative './models/branch'
require_relative './models/tree'
require_relative './models/forest'

$forest = Forest.new

PORT = '4545'
APP_ROOT = File.expand_path('.', __dir__)

get '/' do
    erb :forest
end

get '/*.:ext' do
    return erb :not_found unless ['leaf', 'branch', 'tree'].include?(params['ext'])
    
    path = params['splat'].first + '.' + params['ext']
    parts = path.split('/')

    tree = parts[0]
    branches = parts.length > 2 ? parts[1..-2] : []
    leaf = parts[-1] if parts[-1].end_with?('.leaf', '.branch', '.tree')

    traversal = []
    traversal << tree + '.tree' unless tree == leaf
    branches.each { |branch| traversal << branch + '.branch' }
    traversal << leaf if leaf

    iota = $forest

    traversal[0..-2].each do |id|
        iota = iota.find(id)
        return erb :not_found unless iota
    end

    @leaf = iota.find_leaf(traversal[-1])
    return erb :not_found unless @leaf

    erb :show
end

configure do
    set :bind, '0.0.0.0'
    set :port, PORT
    set :public_folder, File.join(APP_ROOT, 'public')
    set :views, File.join(APP_ROOT, 'views')
    set :environment, :production
    disable :protection
end