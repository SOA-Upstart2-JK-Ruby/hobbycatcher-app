# frozen_string_literal: true

# Page object for suggestion page
class SuggestionPage
  include PageObject

  page_url "#{HobbyCatcher::App.config.APP_HOST}/suggestion/<%=params[:hobby_id]%>"

  div(:warning_message, id: 'flash_bar_danger')
  div(:success_message, id: 'flash_bar_success')

  nav(:navigation, id: 'main_header')
  h5(:hobby_name, id: 'hobby_name')
  h5(:category_name, id: 'category_name')
  img(:hobby_img, id: 'hobby_img')
  button(:try_again, id: 'try-again-btn')
end
