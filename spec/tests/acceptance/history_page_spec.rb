# frozen_string_literal: true

require_relative '../../helpers/acceptance_helper'
require_relative 'pages/history_page'
require_relative 'pages/test_page'
require_relative 'pages/home_page'
require_relative 'pages/suggestion_page'

describe 'History Page Acceptance Tests' do
  include PageObject::PageFactory

  before do
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    # DatabaseHelper.wipe_database
    @browser = Watir::Browser.new :chrome, options: options
  end

  after do
    @browser.close
  end

  it '(HAPPY) should see history if it exists' do
    # GIVEN: user has taken the test at least once

    visit HomePage(&:catch_hobby)


    # WHEN: user goes to the history page
    visit HistoryPage do |page|
      # THEN: they should see the history details
      _(page.first_hobby_row.exists?).must_equal false
      _(page.success_message_element.present?).must_equal true
      _(page.success_message.downcase).must_include 'first'
    end
  end

  describe 'Delete History' do
    it '(HAPPY) should be able to delete a history' do
      # GIVEN: user has taken the test at least once

      visit HomePage(&:catch_hobby)

      visit TestPage do |page|
        _(page.questions[0].answer1_element.click)
        _(page.questions[1].answer1_element.click)
        _(page.questions[2].answer1_element.click)
        _(page.questions[3].answer1_element.click)
        page.see_result
      end


      # WHEN: user goes to the history page and delete the record
      visit HomePage do |page|
        page.view_history
        @browser.url.include? 'history'
      end
      visit HistoryPage do |page|
        page.first_hobby_delete

        # THEN: they should not find the record that has been deleted
        _(page.first_hobby_row.exists?).must_equal false
      end
    end
  end
end
