# frozen_string_literal: true

module Views
  # View for a single course entity
  class Course
    def initialize(course)
      @course = course
    end

    # 為啥不見了
    # def category_name
    #   @course.owncategory.name
    # end

    def entity
      @course
    end

    def image
      @course.image
    end

    def url
      @course.url
    end

    def price
      @course.price
    end

    def title
      @course.title
    end

    def rating
      @course.rating.zero? ? 'null' : @course.rating.round(2)
    end

    def time
      @course.video_length / 60
    end
  end
end
