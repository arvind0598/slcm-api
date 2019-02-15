require 'sinatra'
require 'json'

require_relative 'script.rb'
require_relative 'parser.rb'
require_relative 'utils.rb'

# Sample route
get '/' do
  'API is live.'
end

# Test route to check if login works
post '/login' do
  content_type :json
  data = JSON.parse(request.body.read)
  username, password, error = check_credentials(data)
  
  unless error.nil? 
    return error 
  end

  session = SLCM.get_session_cookie()
  SLCM.login_user(username, password, session).to_json
end

# Route to fetch attendance
post '/bunks' do
  content_type :json
  data = JSON.parse(request.body.read)
  username, password, error = check_credentials(data)

  unless error.nil? 
    return error 
  end

  session = SLCM.get_session_cookie()
  login_status = SLCM.login_user(username, password, session)
  unless login_status[:success]
    return login_status.to_json
  end

  html = SLCM.get_academics_page(session)
  attendance_details = Parser.get_attendance(html)
  { success: true, data: attendance_details }.to_json
end 
