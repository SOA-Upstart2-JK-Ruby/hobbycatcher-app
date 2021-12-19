# frozen_string_literal: true

# Page object for history page
class HistoryPage
  include PageObject

  page_url "#{HobbyCatcher::App.config.APP_HOST}/history"

  div(:warning_message, id: 'flash_bar_danger')
  div(:success_message, id: 'flash_bar_success')

  nav(:navigation, id: 'main_header')
  table(:history_table, id: 'history_table')

  indexed_property(
    :hobbies,
    [
      [:span, :history_time,  { id: 'hobby[%s].time' }],
      [:span, :history_name,  { id: 'hobby[%s].name' }],
      [:a,    :history_link,  { id: 'hobby[%s].link' }]
    ]
  )

  def first_hobby
    hobbies[0]
  end

  def first_hobby_row
    history_table_element.trs[1]
  end

  def first_hobby_delete
    first_hobby_row.button(id: 'hobby[0].delete').click
  end
end
