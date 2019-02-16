require 'sinatra'
require 'json'

require_relative 'requests.rb'
require_relative 'parser.rb'

# Sample route
get '/' do
  'API is live.'
end

# Test route to check if login works
post '/login' do
  content_type :json
  data = JSON.parse(request.body.read)
  username, password, error = Utils.check_credentials(data)
  
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
  username, password, error = Utils.check_credentials(data)

  unless error.nil? 
    return error 
  end

  session = SLCM.get_session_cookie()
  login_status = SLCM.login_user(username, password, session)
  unless login_status[:success]
    return login_status.to_json
  end

  html = SLCM.get_academics_page(session)
  details = Parser.get_attendance(html)
  { success: true, data: details }.to_json
end

# Route to fetch course details
post '/courses' do
  content_type :json
  data = JSON.parse(request.body.read)
  username, password, error = Utils.check_credentials(data)

  unless error.nil? 
    return error 
  end

  session = SLCM.get_session_cookie()
  login_status = SLCM.login_user(username, password, session)
  unless login_status[:success]
    return login_status.to_json
  end

  html = SLCM.get_academics_page(session)
  details = Parser.get_courses(html)
  { success: true, data: details }.to_json
end

# Route to fetch gradesheet details
post '/grades' do
  content_type :json
  data = JSON.parse(request.body.read)
  username, password, error = Utils.check_credentials(data)

  semester = data['semester']
  if semester.nil?
    return Utils.send_status(false, 'Semester is missing').to_json
  else
    conv_status = Utils.map_roman_integer(semester, :int_to_roman)
    unless conv_status[:success]
      return Utils.send_status(false, 'Semester is invalid').to_json
    end
    semester = conv_status[:message]
  end

  unless error.nil? 
    return error 
  end

  session = SLCM.get_session_cookie()
  login_status = SLCM.login_user(username, password, session)
  unless login_status[:success]
    return login_status.to_json
  end

  # TODO: split auth data into own route
  gradesheet_html = SLCM.get_gradesheet_page(session)
  viewstate, eventvalidation = Parser.get_grades_auth(gradesheet_html)
  puts viewstate, eventvalidation

  html = SLCM.get_gradesheet_info(session, viewstate, eventvalidation, semester)
  details = Parser.get_grades(html)
  { success: true, data: details }.to_json
end

