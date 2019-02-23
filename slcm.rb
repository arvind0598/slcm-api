require 'cgi'

class Site
  @@url = {
    base: 'slcm.manipal.edu',
    login: '/loginForm.aspx',
    academics: '/Academics.aspx',
    grades: '/GradeSheet.aspx',
    profile: '/StudentProfile.aspx',
  }

  # header to be attached with every GET request made after logging in
  @@get_header_data = {
    'Accept' => '*/*',
    'Accept-Encoding' => 'gzip, deflate, br',
    'Accept-Language' => 'en-US,en;q=0.5',
    'Connection' => 'keep-alive',
    'Host' => @@url[:base],
    'Cookie' => nil,
    'Referer' => 'https://slcm.manipal.edu/loginForm.aspx',
    'User-Agent' => 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:65.0) Gecko/20100101 Firefox/65.0',
  }

  # header to be attached to the POST request made for login
  @@post_header_data = {
    'Accept' => '*/*',
    'Accept-Encoding' => 'gzip, deflate, br',
    'Accept-Language' => 'en-US,en;q=0.5',
    'Cache-Control' => 'no-cache',
    'Connection' => 'keep-alive',
    'Content-Type' => 'application/x-www-form-urlencoded; charset=utf-8',
    'Host' => @@url[:base],
    'Referer' => 'https://slcm.manipal.edu/loginForm.aspx',
    'X-MicrosoftAjax' => 'Delta=true',
    'X-Requested-With' => 'XMLHttpRequest',
    'User-Agent' => 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:65.0) Gecko/20100101 Firefox/65.0',
  }

  # functions to get URI objects for a particular link
  def get_login_url
    URI('https://' + @@url[:base] + @@url[:login])
  end

  def get_academics_url
    URI('https://' + @@url[:base] + @@url[:academics])
  end

  def get_grades_url
    URI('https://' + @@url[:base] + @@url[:grades])
  end

  def get_profile_url
    URI('https://' + @@url[:base] + @@url[:profile])
  end

  # Expects the set-cookie header, and parses it to return just the Session ID
  # This works because there is a constant format to the string.
  # Example Input: ASP.NET_SessionId=tb4sflkpjbhutvfw1sioh5kv; path=/; HttpOnly
  # Example Output: ASP.NET_SessionId=tb4sflkpjbhutvfw1sioh5kv;
  def parse_session_cookie(cookie)
    cookie.split(';').first
  end

  # Expects the username and password for logging in, and places it in the template
  # This works because the other values are constant in every request made
  def make_post_body(username, password)
    "ScriptManager1=updpnl%7CbtnLogin&__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE=%2FwEPDwULLTE4NTA1MzM2ODIPZBYCAgMPZBYCAgMPZBYCZg9kFgICAw8PFgIeB1Zpc2libGVoZGRkZQeElbA4UBZ%2FsIRqcKZDYpcgTP0%3D&__VIEWSTATEGENERATOR=6ED0046F&__EVENTVALIDATION=%2FwEdAAbdzkkY3m2QukSc6Qo1ZHjQdR78oILfrSzgm87C%2Fa1IYZxpWckI3qdmfEJVCu2f5cEJlsYldsTO6iyyyy0NDvcAop4oRunf14dz2Zt2%2BQKDEIHFert2MhVDDgiZPfTqiMme8dYSy24aMNCGMYN2F8ckIbO3nw%3D%3D&txtUserid=#{username}&txtpassword=#{password}&__ASYNCPOST=true&btnLogin=Sign%20in";
  end

  def make_gradesheet_body(semester, viewstate, eventvalidation)
    "ctl00%24ScriptManager1=ctl00%24ContentPlaceHolder1%24UpdatePanel1%7Cctl00%24ContentPlaceHolder1%24ddlSemester&__EVENTTARGET=ctl00%24ContentPlaceHolder1%24ddlSemester&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=#{CGI::escape(viewstate)}&__VIEWSTATEGENERATOR=47C4ACAC&__EVENTVALIDATION=#{CGI::escape(eventvalidation)}&ctl00%24ContentPlaceHolder1%24ddlSemester=#{semester}&__ASYNCPOST=true&"
  end

  def make_academics_body(semester, viewstate, eventvalidation)
    "ctl00%24ScriptManager1=ctl00%24ContentPlaceHolder1%24UpdatePanel1%7Cctl00%24ContentPlaceHolder1%24LinkButton1&__EVENTTARGET=ctl00%24ContentPlaceHolder1%24LinkButton1&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=#{CGI::escape(viewstate)}&__VIEWSTATEGENERATOR=2FB222ED&__EVENTVALIDATION=#{CGI::escape(eventvalidation)}&ctl00%24ContentPlaceHolder1%24ddlSemesterCourseDetails=#{semester}&ctl00%24ContentPlaceHolder1%24txtAttenFromDate=&ctl00%24ContentPlaceHolder1%24txtAttenToDate=&__ASYNCPOST=true&"
  end

  # header generation
  def make_post_headers(length, session)
    @@post_header_data['Content-Length'] = length
    @@post_header_data['Cookie'] = session
    return @@post_header_data
  end

  def make_get_headers(session)
    @@get_header_data['Cookie'] = session
    return @@get_header_data
  end
end