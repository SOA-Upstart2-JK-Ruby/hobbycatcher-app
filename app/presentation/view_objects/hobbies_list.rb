# frozen_string_literal: true

require_relative 'hobby'

module Views
  # View for a single hobbies list entity
  class HobbiesList
    def initialize(hobbies)
      @hobbies = hobbies.map.with_index { |hobby, index| Hobby.new(hobby, index) }
    end

    def each(&block)
      @hobbies.each(&block)
    end

    def any?
      @hobbies.any?
    end

    def first
      @hobbies.first
    end
  end
end
