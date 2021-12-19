# frozen_string_literal: true

require_relative 'category'
require_relative 'course'

module Views
  # View for a single hobby entity
  class Hobby
    def initialize(record, index = nil)
      @record   = record
      @hobby    = record.hobby_id
      @index    = index
    end

    def entity
      @hobby
    end

    def id
      @hobby.id
    end

    def index_str
      "hobby[#{@index}]"
    end

    def name
      @hobby.name
    end

    def img
      @hobby.img
    end

    def user_num
      @hobby.user_num
    end

    def description
      @hobby.description
    end

    def time
      Time.parse(@record.updated_at)
    end

    def standard_time
      time.strftime('%F %R')
    end

    def result_url
      "/suggestion/#{@hobby.id}"
    end
  end
end
