# frozen_string_literal: true

require 'roar/decorator'
require 'representable/json/collection'
require 'roar/json'

module HobbyCatcher
  module Representer
    # Represents test information about test page
    class Test < Roar::Decorator
      include Representable::JSON

      property :description
      property :answerA
      property :answerB
      property :button_name

      collection_representer class: OpenStruct
    end
  end
end
