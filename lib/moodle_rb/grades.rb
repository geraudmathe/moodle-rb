module MoodleRb
  class Grades
    include HTTParty
    include Utility

    attr_reader :token, :query_options

    def initialize(token, url, query_options)
      @token = token
      @query_options = query_options
      self.class.base_uri url
    end

    def by_assignment(assignment_id)
      response = self.class.post(
        '/webservice/rest/server.php',
        {
          :query => query_hash('mod_assign_get_grades', token),
          :body => {
            :assignmentids => api_array(assignment_id)
          }
        }.merge(query_options)
      )
      check_for_errors(response)
      response.parsed_response['assignments']
    end

    def by_course(course_id, user_id=nil, group_id = nil)
      response = self.class.post(
        '/webservice/rest/server.php',
        {
          :query => query_hash('gradereport_user_get_grade_items', token),
          :body => {
            :courseid => course_id,
            :userid => user_id,
            :groupid => group_id
          }
        }.merge(query_options)
      )
      check_for_errors(response)
      response.parsed_response['items']
    end
  end
end
