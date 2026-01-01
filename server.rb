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
    begin
        return pass unless ['leaf', 'branch', 'tree'].include?(params['ext'])
        # Get path as parts
        path = params['splat'].first + '.' + params['ext']
        parts = path.split('/')
        # Categorize parts
        tree, leaf = parts[0], parts[-1]
        branches = parts.length > 2 ? parts[1..-2] : []
        # Build traversal path of IDs
        traversal = []
        traversal << tree + '.tree' unless tree == leaf
        branches.each { |branch| traversal << branch + '.branch' }
        traversal << leaf if leaf
        # Traverse and cast last part as a leaf
        iota = $forest
        traversal[0..-2].each { |id| iota = iota.find(id) }
        @leaf = iota.find_leaf(traversal[-1])
        erb :show
    rescue
        return halt(404)
    end
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