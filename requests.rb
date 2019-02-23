require 'net/http'
require 'httparty'
require 'json'
require 'pry'

require_relative 'slcm.rb'
require_relative 'utils.rb'

$slcm = Site.new
$timeout = 20

class SLCM
  def self.get_session_cookie
    begin
      response = HTTParty.get(
        $slcm.get_login_url(), 
        timeout: $timeout,
      )
    rescue StandardError => error
      return Utils.send_status(false, 'An error occured.')
    end
    cookie = response.headers['set-cookie']
    session = $slcm.parse_session_cookie(cookie)
    return Utils.send_status(true, session)
  end
  
  def self.login_user(username, password, session)
    post_body = $slcm.make_post_body(username, password)
    post_headers = $slcm.make_post_headers(post_body.to_json.length.to_s, session)
    begin
      response = HTTParty.post(
        $slcm.get_login_url(),
        timeout: $timeout,
        headers: post_headers,
        body: post_body,
      )
    rescue StandardError => error
      return Utils.send_status(false, 'An error occured.')
    end
    status = response.length < 100
    if status 
      return Utils.send_status(true, 'Login Successful!')
    else
      return Utils.send_status(false, 'Invalid Credentials.')
    end
  end
  
  def self.get_academics_page(session)
    get_headers = $slcm.make_get_headers(session)
    begin
      response = HTTParty.get(
        $slcm.get_academics_url(),
        timeout: $timeout,
        headers: get_headers,
      )
    rescue StandardError => error
      return false, nil
    end
    return true, response
  end

  def self.get_gradesheet_page(session)
    get_headers = $slcm.make_get_headers(session)
    begin
      response = HTTParty.get(
        $slcm.get_grades_url(),
        timeout: $timeout,
        headers: get_headers,
      )
    rescue StandardError => error
      return false, nil
    end
    return true, response
  end

  def self.get_gradesheet_info(session, viewstate, eventvalidation, semester)
    post_body = $slcm.make_gradesheet_body(semester, viewstate, eventvalidation)
    post_headers = $slcm.make_post_headers(post_body.to_json.length.to_s, session)
    post_headers['Referer'] = $slcm.get_grades_url().to_s
    begin  
      response = HTTParty.post(
        $slcm.get_grades_url(),
        timeout: $timeout,
        headers: post_headers,
        body: post_body,
      )
    rescue StandardError => error
      return false, nil
    end
    return true, response
  end

  def self.get_student_info(session)
    get_headers = $slcm.make_get_headers(session)
    begin
      response = HTTParty.get(
        $slcm.get_profile_url(),
        timeout: $timeout,
        headers: get_headers,
      )
    rescue StandardError => error
      return false, nil
    end
    return true, response
  end
end