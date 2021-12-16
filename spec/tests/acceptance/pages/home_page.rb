# frozen_string_literal: true

# Page object for home page
# rubocop:disable Style/RedundantSelf
class HomePage
  include PageObject

  page_url HobbyCatcher::App.config.APP_HOST

  div(:warning_message, id: 'flash_bar_danger')
  div(:success_message, id: 'flash_bar_success')

  nav(:navigation, id: 'main_header')
  h1(:homepage_title, id: 'homepage_title')
  button(:catch_hobby, id: 'catch_hobby')
  button(:view_history, id: 'view_history')
end

