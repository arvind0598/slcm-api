require 'nokogiri'

class Parser

  def self.get_courses(html)
    data = Nokogiri::HTML(html)
    course_details = data.css('#ContentPlaceHolder1_UpdatePanel1 .table.table-bordered td')

    course_map = {}

    course_details.each_slice(9) { |course|
      course_data = {}
      course_data['name'] = course[1].text.split.map(&:capitalize).join(' ')
      course_data['semester'] = course[4].text
      course_data['credits'] = course[5].text.to_f
      course_map[course[0].text.split.join] = course_data
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
end
