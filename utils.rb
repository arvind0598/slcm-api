class Utils
  def self.send_status(status, message = nil)
    { success: status, message: message }
  end

  def self.send_failure
    send_status(false, 'An error occured.').to_json
  end
  
  def self.check_credentials(data)
    username = data['username']
    password = data['password']
    error = nil
    if username.nil? || password.nil? || !username.match(/^(\d){9}$/)
      error = send_status(false, 'Invalid Credentials')
    end
    return username, password, error
  end

  def self.check_semester(data)
    semester = data['semester']
    if semester.nil?
      return send_status(false, 'Semester is missing')
    else
      conv_status = map_roman_integer(semester, :int_to_roman)
      unless conv_status[:success]
        return send_status(false, 'Semester is invalid')
      end
      return send_status(true, conv_status[:message])
    end
  end

  def self.map_roman_integer(num, direction)
    roman_nums = ['', 'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII']
    status = nil
    begin
      if direction == :roman_to_int
        status = roman_nums.find_index(num)
      else
        if num.to_i <= 0 
          return send_status(false, 'Invalid semester.')
        end
        status = roman_nums.at(num.to_i)
      end
    rescue StandardError => error
      return send_status(false, 'Invalid semester.')
    end
    return send_status(!status.nil?, status)
  end

  def self.auth_request(data)
    username, password, error = check_credentials(data)

    unless error.nil? 
      return error 
    end

    session_status = SLCM.get_session_cookie()
    unless session_status[:success]
      return session_status
    end
    session = session_status[:message]
    
    login_status = SLCM.login_user(username, password, session)
    unless login_status[:success]
      return login_status
    end

    send_status(true, session)
  end

  def self.auth_request_with_semester(data)
    username, password, error = check_credentials(data)

    unless error.nil? 
      return error 
    end

    semester_status = Utils.check_semester(data)
    unless semester_status[:success]
      return semester_status
    end
    semester = semester_status[:message]

    session_status = SLCM.get_session_cookie()
    unless session_status[:success]
      return session_status
    end
    session = session_status[:message]
    
    login_status = SLCM.login_user(username, password, session)
    unless login_status[:success]
      return login_status
    end

    { success: true, session: session, semester: semester }
  end
end  
