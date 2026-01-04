helpers do
    $given_tokens = []

    def new_token
        token = Array.new(12) { [*'0'..'9', *'a'..'z', *'A'..'Z'].sample }.join
        $given_tokens << token
        return token
    end

    def is_valid_key?(attempt)
        return true if $config['api_key'] == attempt
        return true if $config['pass_key'] == attempt
        return false
    end

    def is_logged_in?
        # Check if sent by param (API)
        api_key = request.params['api_key']
        return true if api_key && is_valid_key?(api_key)
        # Check if cookie is assigned
        cookie = request.cookies[$config['cookie_name']]
        return cookie && $given_tokens.include?(cookie)
    end

    def protect!
        redirect '/login' unless is_logged_in?
    end
end

get '/login' do
    erb :login
end

post '/login' do
    data = JSON.parse(request.body.read)
    attempt = data['attempt']
    if is_valid_key?(attempt)
        token = new_token
        response.set_cookie($config['cookie_name'], value: token, path: '/', max_age: '3600')
        content_type :json
        status 200
        { success: true, token: token }.to_json
    else
        content_type :json
        status 401
        { success: false, error: "Invalid password" }.to_json
    end
end