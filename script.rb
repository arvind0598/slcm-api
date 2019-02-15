require 'net/http'
require 'httparty'
require 'json'
require 'pry'

require_relative 'slcm.rb'

$slcm = Site.new
$timeout = 20

class SLCM

  def self.send_status(status, message = nil)
    {
      success: status,
      message: message,
    }
  end

  def self.get_session_cookie
    response = HTTParty.get(
      $slcm.get_login_url(), 
      timeout: $timeout,
    )
    cookie = response.headers['set-cookie']
    session = $slcm.parse_session_cookie(cookie)
    return session
  end
  
  def self.login_user(username, password, session)
    post_body = $slcm.make_post_body(username, password)
    post_headers = $slcm.make_post_headers(post_body.to_json.length.to_s, session)
    response = HTTParty.post(
      $slcm.get_login_url(),
      timeout: $timeout,
      headers: post_headers,
      body: post_body,
    )
    status = response.length < 100
    if status 
      return send_status(true, 'Login Successful!')
    else
      return send_status(false, 'Invalid Credentials.')
    end
  end
  
  def self.get_academics_page(session)
    get_headers = $slcm.make_get_headers(session)
    response = HTTParty.get(
      $slcm.get_academics_url(),
      timeout: $timeout,
      headers: get_headers,
    )
  end
end