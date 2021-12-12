# frozen_string_literal: true

# Page object for test page
# rubocop:disable Style/RedundantSelf
class TestPage
  include PageObject

  page_url "#{HobbyCatcher::App.config.APP_HOST}/test"

  div(:warning_message, id: 'flash_bar_danger')
  div(:success_message, id: 'flash_bar_success')

  radio(:answer1, id: "#{question.button_name}1")
  radio(:answer2, id: "#{question.button_name}2")
  button(:see_result, id: 'hobby-form-submit-question')

  def see_result
    self.see_result
  end
end
# rubocop:enable Style/RedundantSelf
