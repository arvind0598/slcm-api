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
      course_data['credits'] = course[5].text
      course_map[course[0].text] = course_data
    }
    return course_map
  end

  def self.get_academics_details(html)
    courses = get_courses(html).to_json
    return courses
  end
end
