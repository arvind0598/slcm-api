require 'nokogiri'

class Parser
  def self.get_course_name(name)
    # name.split.map{|x| 
    #   if x.length > 3 || x == 'LAB'
    #     x.capitalize
    #   elsif Utils.map_roman_integer(x, :roman_to_int)[:success]
    #     x.upcase
    #   else
    #     x.downcase
    #   end
    # }.join(' ')
    name.strip
  end

  def self.get_courses(html)
    data = Nokogiri::HTML(html)
    course_details = data.css('.row + .table-responsive.mt-10 .table.table-bordered td')

    course_map = {}

    course_details.each_slice(9) { |course|
      subject_code = course[0].text.split.join
      name = get_course_name(course[1].text)
      semester = Utils.map_roman_integer(course[4].text, :roman_to_int)[:message]
      credits = course[5].text.to_f
      course_map[subject_code] = { name: name, semester: semester, credits: credits }
    }
    return course_map
  end

  def self.get_attendance(html)
    data = Nokogiri::HTML(html)
    attendance_details = data.css('#tblAttendancePercentage td')

    attendance_map = {}

    attendance_details.each_slice(8) { |course|
      subject_code = course[1].text.split.join
      attendance_total = course[4].text
      attendance_present = course[5].text
      course_data = {
        total: attendance_total.to_i,
        present: attendance_present.to_i,
      }
      attendance_map[subject_code] = course_data
    }
    return attendance_map
  end

  def self.get_auth(html)
    data = Nokogiri::HTML(html)
    viewstate = data.at('input[name="__VIEWSTATE"]')['value']
    eventvalidation = data.at('input[name="__EVENTVALIDATION"]')['value']
    return viewstate, eventvalidation
  end

  def self.get_grades(html)
    data = Nokogiri::HTML(html)
    grades_details = data.css('#ContentPlaceHolder1_grvGradeSheet td')

    gpa = data.css('#ContentPlaceHolder1_lblGPA').text.to_f
    cgpa = data.css('#ContentPlaceHolder1_lblCGPA').text.to_f
    total_credits = data.css('#ContentPlaceHolder1_LabelTotalcredit').text.to_f

    grades_map = {}

    grades_details.each_slice(8) { |course|
      subject_code = course[1].text.split.join
      name = get_course_name(course[2].text)
      grade = course[3].text.strip
      credits = course[4].text.to_f
      grades_map[subject_code] = { name: name, grade: grade, credits: credits }     
    }

    details = { cgpa: cgpa, gpa: gpa, credits: total_credits, grades: grades_map }
    return details
  end

  def self.get_internal_marks(html)
    data = Nokogiri::HTML(html)
    marks_details = data.css('.panel-collapse.collapse')

    marks_map = {}

    marks_details.each{ |x|
      subject_code = x['id']
      subject_marks_details = x.css('td')
      subject_map = {}

      subject_marks_details.each_slice(3) { |test|
        name = test[0].text
        if name.include?'Total'
          next
        end

        total = test[1].text.to_f
        score = test[2].text.to_f
        subject_marks = { score: score, total: total }
        subject_map[name] = subject_marks
      }

      marks_map[subject_code] = subject_map
    }

    marks_map
  end

  def self.get_profile(html)
    data = Nokogiri::HTML(html)
    profile_details = data.css('#ContentPlaceHolder1_pnlAdmission input.form-control')

    response = {}
    profile_details.each{ |x|
      # TODO: Use substr instead of split, probably faster
      key = x['name'].split('txt').last
      value = x['value']
      response[key] = value    
    }

    return response
  end
end
