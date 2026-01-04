get '/' do
    protect!
    erb :forest
end

get '/reload' do
    protect!
    $forest.reload
    redirect '/'
end

get '/*/edit' do
    protect!
    begin
        # Get path as parts
        @path = params['splat'].first
        @path = '' if @path == 'forest'
        @is_branch = params['branch'].to_i == 1
        @is_tree = params['tree'].to_i == 1
        parts = @path.split('/')
        parts = [''] if parts == []
        edit = [
            parts.last.end_with?('.leaf'),
            parts.last.end_with?('.branch'),
            parts.last.end_with?('.tree'),
        ].any?
        if edit
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
            leaf = iota.find_leaf(traversal[-1])
            @raw = leaf.raw
        else
            @raw = ['---', "key: temp_key_#{rand(99999)}", 'title: untitled', '---', ]
        end
        erb :edit
    rescue => error
        puts error.message
        puts error.backtrace
        return halt(404)
    end
end

post '/*/edit' do
    protect!
    request.body.rewind
    data = request.body.read.split("\n")
    is_branch = params['branch'].to_i == 1
    is_tree = params['tree'].to_i == 1
    path = params['splat'].first.split("/")
    path = [''] if path == ['forest']
    edit = [
        path.last.end_with?('.leaf'),
        path.last.end_with?('.branch'),
        path.last.end_with?('.tree'),
    ].any?

    if edit
        filepath = File.join('forest', path)
    else
        filename = 'untitled'
        if data.first == ATTR_START
            data[1..-1].each do |line|
                key, value = line.split(': ', 2)
                filename = value if key == 'key'
                break if line == ATTR_END
            end
        end
        if is_branch
            filepath = File.join('forest', path, filename, filename + '.branch')
            dirpath = File.join('forest', path, filename)
        elsif is_tree
            filepath = File.join('forest', path, filename, filename + '.tree')
            dirpath = File.join('forest', path, filename)
        else
            filepath = File.join('forest', path, filename + '.leaf')
            dirpath = nil
        end
    end

    puts "Path: #{filepath}"
    puts "Data: #{data.inspect}"

    Dir.mkdir(dirpath) if dirpath
    File.write(filepath, data.join("\n"))

    $forest.reload

    content_type :json
    { success: true }.to_json
end

get '/*.:ext' do
    protect!
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
        traversal[0..-2].each do |id|
            puts "Finding [id=\"#{id}\"]..."
            iota = iota.find(id)
        end
        @leaf = iota.find_leaf(traversal[-1])
        erb :show
    rescue => error
        puts error
        return halt(404)
    end
end