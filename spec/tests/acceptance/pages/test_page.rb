# frozen_string_literal: true

# Page object for test page
# rubocop:disable Style/RedundantSelf
class TestPage
  include PageObject

  page_url "#{HobbyCatcher::App.config.APP_HOST}/test"

  div(:warning_message, id: 'flash_bar_danger')
  div(:success_message, id: 'flash_bar_success')

  # form(:show-hobby-form, id: 'show-hobby-form')
  button(:see_result, id: 'hobby-form-submit-question')

  indexed_property(
    :questions,
    [
      [:div,   :question, { id: 'question[%s].question' }],
      [:radio, :answer1,  { id: 'question[%s].answer1' }],
      [:radio, :answer2,  { id: 'question[%s].answer2' }]
    ]
  )
end

