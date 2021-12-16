# frozen_string_literal: true

require_relative '../../helpers/acceptance_helper'
require_relative 'pages/home_page'
require_relative 'pages/test_page'
require_relative 'pages/suggestion_page'

describe 'Suggestion Page Acceptance Tests' do
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

  describe 'Visit Suggestion page' do
    it '(HAPPY) suggest right hobby' do
      # GIVEN: user has taken the test
      visit HomePage do |page|
        page.catch_hobby
        @browser.url.include? 'test'
      end

      # WHEN: user answers the questions with the answers
      visit TestPage do |page|
        _(page.questions[0].answer1_element.click)
        _(page.questions[1].answer1_element.click)
        _(page.questions[2].answer1_element.click)
        _(page.questions[3].answer1_element.click)
        page.see_result
      end

      # THEN: they should see hobby suggestion of Lion
      visit(SuggestionPage, using_params: { hobby_id: HOBBY_ID }) do |page|
        page.url.include? 'suggestion/1'
        _(page.hobby_name).must_equal 'LION'
        _(page.category_name).must_equal 'Category: Dance'
      end
    end
  end

  describe 'Visit Suggestion page' do
    it '(HAPPY) should see results' do
      # WHEN: user visit the home page
      visit(SuggestionPage, using_params: { hobby_id: HOBBY_ID }) do |page|
        # THEN: they should see basic headers and two buttons
        _(page.navigation).must_equal 'HobbyCatcher'
        _(page.hobby_name).must_equal 'LION'
        _(page.category_name).must_equal 'Category: Dance'
        _(page.hobby_img_element.present?).must_equal true
        _(page.try_again_element.present?).must_equal true
      end
    end
  end

  describe 'Click try again' do
    it '(HAPPY) redirect to home page' do
      # WHEN: user click the button
      visit(SuggestionPage, using_params: { hobby_id: HOBBY_ID }) do |page|
        page.try_again
        # THEN: they should find themselves on the home page
        @browser.url.include? homepage
      end
    end
  end
end
