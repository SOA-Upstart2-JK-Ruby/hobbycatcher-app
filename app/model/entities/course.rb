# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module HobbyCatcher
  module Entity
    # Domain entity for courses
    class Course < Dry::Struct
      include Dry.Types

      attribute :id,        Integer.optional
      attribute :course_id, Strict::Integer
      attribute :title,     Strict::String
      attribute :url,       Strict::String
      attribute :price,     Strict::String
      attribute :image,     Strict::String
      attribute :rating,    Strict::Float
    end
  end
end
