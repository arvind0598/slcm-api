def check_credentials(data)
  username = data['username']
  password = data['password']
  error = nil
  if username.nil? || password.nil? || !username.match(/^(\d){9}$/)
    error = { success: false, message: 'Invalid Credentials.'}.to_json
  end
  return username, password, error
end