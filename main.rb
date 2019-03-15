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

  session_status = SLCM.get_session_cookie()
  unless session_status[:success]
    return session_status.to_json
  end

  session = session_status[:message]
  SLCM.login_user(username, password, session).to_json
end

# Route to fetch attendance
post '/bunks' do
  content_type :json
  data = JSON.parse(request.body.read)
  auth_status = Utils.auth_request(data)
  unless auth_status[:success]
    return auth_status.to_json
  end

  session = auth_status[:message]

  html_success, html = SLCM.get_academics_page(session)
  unless html_success
    return Utils.send_failure()
  end

  details = Parser.get_attendance(html)
  { success: true, data: details }.to_json
end

# Route to fetch course details
post '/courses' do
  content_type :json
  data = JSON.parse(request.body.read)
  auth_status = Utils.auth_request_with_semester(data)
  unless auth_status[:success]
    return auth_status.to_json
  end

  semester = auth_status[:semester]
  session = auth_status[:session]

  academics_html_success, academics_html = SLCM.get_academics_page(session)
  unless academics_html_success
    return Utils.send_failure()
  end

  viewstate, eventvalidation = Parser.get_auth(academics_html)

  html_success, html = SLCM.get_academics_info(session, viewstate, eventvalidation, semester)
  unless html_success
    return Utils.send_failure()
  end

  details = Parser.get_courses(html)
  { success: true, data: details }.to_json
end

# Route to fetch gradesheet details
post '/grades' do
  content_type :json
  data = JSON.parse(request.body.read)
  auth_status = Utils.auth_request_with_semester(data)
  unless auth_status[:success]
    return auth_status.to_json
  end

  semester = auth_status[:semester]
  session = auth_status[:session]

  gradesheet_html_success, gradesheet_html = SLCM.get_gradesheet_page(session)
  unless gradesheet_html_success
    return Utils.send_failure()
  end

  viewstate, eventvalidation = Parser.get_auth(gradesheet_html)

  html_success, html = SLCM.get_gradesheet_info(session, viewstate, eventvalidation, semester)
  unless html_success
    return Utils.send_failure()
  end

  details = Parser.get_grades(html)
  { success: true, data: details }.to_json
end

# Route to fetch student details
post '/student' do
  content_type :json
  data = JSON.parse(request.body.read)

  auth_status = Utils.auth_request(data)
  unless auth_status[:success]
    return auth_status.to_json
  end

  session = auth_status[:message]

  html_success, html = SLCM.get_student_page(session)
  unless html_success
    return Utils.send_failure()
  end

  details = Parser.get_profile(html)
  { success: true, data: details }.to_json
end

# Route to fetch internal marks details
post '/marks' do
  content_type :json
  data = JSON.parse(request.body.read)
  auth_status = Utils.auth_request_with_semester(data)
  unless auth_status[:success]
    return auth_status.to_json
  end

  semester = auth_status[:semester]
  session = auth_status[:session]

  academics_html_success, academics_html = SLCM.get_academics_page(session)
  unless academics_html_success
    return Utils.send_failure()
  end

  viewstate, eventvalidation = Parser.get_auth(academics_html)

  html_success, html = SLCM.get_marks_info(session, viewstate, eventvalidation, semester)
  unless html_success
    return Utils.send_failure()
  end

  details = Parser.get_internal_marks(html)
  { success: true, data: details }.to_json
end

# Route to fetch all details
post '/init' do
  content_type :json
  return Utils.send_status(false, 'Route is incomplete').to_json
end
