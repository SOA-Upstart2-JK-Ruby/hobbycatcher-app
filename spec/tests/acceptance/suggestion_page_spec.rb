# frozen_string_literal: true

require_relative '../../helpers/acceptance_helper'
require_relative 'pages/home_page'
require_relative 'pages/test_page'
require_relative 'pages/suggestion_page'

describe 'Suggestion Page Acceptance Tests' do
  include PageObject::PageFactory

  before do
    DatabaseHelper.wipe_database
    # Headless error? https://github.com/leonid-shevtsov/headless/issues/80
    # @headless = Headless.new
    @browser = Watir::Browser.new
  end

  after do
    @browser.close
    # @headless.destroy
  end

  describe 'Visit Suggestion page' do
    it '(HAPPY) suggest right hobby' do
      # GIVEN: user has taken the test
      visit HomePage do |page|
        page.catch_hobby
      end

      # WHEN: user answers the questions with the answers
      visit TestPage do |page|
        @browser.radio(id: 'type1').click
        @browser.radio(id: 'difficulty1').click
        @browser.radio(id: 'freetime1').click
        @browser.radio(id: 'emotion1').click
        page.see_result
      end
   
      visit SuggestionPage do |page|
        # THEN: they should see hobby suggestion of Lion
        _(page.hobby_name).must_equal 'LION'
        _(page.category_name).must_equal 'Dance'
      end
    end
  end

  describe 'Click try again' do
    it '(HAPPY) redirect to home page' do
      # WHEN: user click the button
      page.try_again
      # THEN: they should find themselves on the home page
      @browser.goto homepage
    end
  end
end
