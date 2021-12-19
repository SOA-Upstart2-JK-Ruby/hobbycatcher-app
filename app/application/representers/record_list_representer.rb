# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'openstruct_with_links'
require_relative 'record_representer'

module HobbyCatcher
  module Representer
    # Represents essential Category information for API output
    class RecordList < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      collection :records, extend: Representer::Record,
                          class: Response::OpenStructWithLinks
    end
  end
end
