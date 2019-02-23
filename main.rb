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
  username, password, error = Utils.check_credentials(data)

  unless error.nil? 
    return error 
  end

  session_status = SLCM.get_session_cookie()
  unless session_status[:success]
    return session_status.to_json
  end
  session = session_status[:message]
  
  login_status = SLCM.login_user(username, password, session)
  unless login_status[:success]
    return login_status.to_json
  end

  html_success, html = SLCM.get_academics_page(session)
  unless html_success
    return Utils.send_status(false, 'An error occured.').to_json
  end

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

  semester_status = Utils.check_semester(data)
  unless semester_status[:success]
    return semester_status.to_json
  end
  semester = semester_status[:message]

  session_status = SLCM.get_session_cookie()
  unless session_status[:success]
    return session_status.to_json
  end
  session = session_status[:message]
  
  login_status = SLCM.login_user(username, password, session)
  unless login_status[:success]
    return login_status.to_json
  end

  academics_html_success, academics_html = SLCM.get_academics_page(session)
  unless academics_html_success
    return Utils.send_status(false, 'An error occured a.').to_json
  end

  viewstate, eventvalidation = Parser.get_auth(academics_html)

  html_success, html = SLCM.get_academics_info(session, viewstate, eventvalidation, semester)
  unless html_success
    return Utils.send_status(false, 'An error occured b.').to_json
  end

  details = Parser.get_courses(html)
  { success: true, data: details }.to_json
end

# Route to fetch gradesheet details
post '/grades' do
  content_type :json
  data = JSON.parse(request.body.read)
  username, password, error = Utils.check_credentials(data)
  unless error.nil? 
    return error 
  end

  semester_status = Utils.check_semester(data)
  unless semester_status[:success]
    return semester_status.to_json
  end
  semester = semester_status[:message]

  session_status = SLCM.get_session_cookie()
  unless session_status[:success]
    return session_status.to_json
  end
  session = session_status[:message]

  login_status = SLCM.login_user(username, password, session)
  unless login_status[:success]
    return login_status.to_json
  end

  # TODO: split auth data into own route
  gradesheet_html_success, gradesheet_html = SLCM.get_gradesheet_page(session)
  unless gradesheet_html_success
    return Utils.send_status(false, 'An error occured.').to_json
  end

  viewstate, eventvalidation = Parser.get_auth(gradesheet_html)

  html_success, html = SLCM.get_gradesheet_info(session, viewstate, eventvalidation, semester)
  unless html_success
    return Utils.send_status(false, 'An error occured.').to_json
  end

  details = Parser.get_grades(html)
  { success: true, data: details }.to_json
end

# Route to fetch student details
post '/student' do
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
  
  login_status = SLCM.login_user(username, password, session)
  unless login_status[:success]
    return login_status.to_json
  end

  html_success, html = SLCM.get_student_page(session)
  unless html_success
    return Utils.send_status(false, 'An error occured.').to_json
  end

  details = Parser.get_profile(html)
  return details.to_json
end

# Route to fetch internal marks details
post '/marks' do
  content_type :json
  return Utils.send_status(false, 'Route is incomplete').to_json
end

# Route to fetch all auth details
post '/init' do
  content_type :json
  return Utils.send_status(false, 'Route is incomplete').to_json
end
