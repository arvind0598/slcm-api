require_relative 'script.rb'

def get_test_credentials
  file = File.read('config.json')
  JSON.parse(file)
end

cred = get_test_credentials()

session = SLCM.get_session_cookie()
login_status = SLCM.login_user(cred['username'], cred['password'], session)

if login_status[:success]
  data = SLCM.get_academics_page(session)
  puts data
else
  puts 'Login was not succesful'
end
