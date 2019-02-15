require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'httparty'
require 'json'
require 'pry'

require_relative 'slcm.rb'

$slcm = Site.new
$timeout = 10

def get_test_credentials
  file = File.read('config.json')
  JSON.parse(file)
end

def get_session_cookie
  response = HTTParty.get(
    $slcm.get_login_url(), 
    timeout: $timeout,
  )
  cookie = response.headers['set-cookie']
  session = $slcm.parse_session_cookie(cookie)
  return session
end

def login_user(username, password, session)
  # TODO: check if username and password are valid
  post_body = $slcm.make_post_body(username, password)
  post_headers = $slcm.make_post_headers(post_body.to_json.length.to_s, session)
  puts post_body, post_headers
  response = HTTParty.post(
    $slcm.get_login_url(),
    timeout: $timeout,
    headers: post_headers,
    body: post_body,
  )
  print response
end

def get_academics_page(session)
  get_headers = $slcm.make_get_headers(session)
  response = HTTParty.get(
    $slcm.get_academics_url(),
    timeout: $timeout,
    headers: get_headers,
  )
end

cred = get_test_credentials()

session = get_session_cookie()
print session
login_user(cred['username'], cred['password'], session)
data = get_academics_page(session)
puts data