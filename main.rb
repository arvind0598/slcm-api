require_relative 'script.rb'
require_relative 'parser.rb'

def get_test_credentials
  file = File.read('config.json')
  JSON.parse(file)
end

cred = get_test_credentials()

session = SLCM.get_session_cookie()
login_status = SLCM.login_user(cred['username'], cred['password'], session)

if login_status[:success]
  academics_html = SLCM.get_academics_page(session)
  academics_data = Parser.get_academics_details(academics_html)
else
  puts 'Login was not succesful'
end
