# frozen_string_literal: true

require_relative '../../helpers/acceptance_helper'
require_relative 'pages/home_page'
require_relative 'pages/test_page'
require_relative 'pages/suggestion_page'

describe 'Test Page Acceptance Tests' do
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

  describe 'See Test Questions and Answers' do
    it '(HAPPY) see the answer radio' do
      # GIVEN: user enter the test page
      visit HomePage(&:catch_hobby)

      # THEN: should see test page elements
      visit TestPage do |page|
        _(page.answer1.present?).must_equal true
        _(page.answer2.present?).must_equal true
        _(page.see_result_element.present?).must_equal true
      end
    end
  end

  describe 'Answer the Questions' do
    it '(HAPPY) provide the correct hobby suggestion based on the test answer' do
      # GIVEN: user enter the test page
      visit HomePage(&:catch_hobby)

      # WHEN: answer the question with the answers
      visit TestPage do |page|
        @browser.radio(id: 'type1').click
        @browser.radio(id: 'difficulty1').click
        @browser.radio(id: 'freetime1').click
        @browser.radio(id: 'emotion1').click
        page.see_result
      end

      # THEN: they should see hobby suggestion of Lion
      visit SuggestionPage do |page|
        _(page.hobby_name).must_equal 'LION'
        _(page.category_name).must_equal 'Dance'
      end
    end

    it '(BAD) should report error if user does not answer all the questions' do
      # GIVEN: user enter the test page
      visit HomePage(&:catch_hobby)

      # WHEN: user does not answer all of the questions
      visit TestPage do |page|
        # help me
        page.see_result

        # THEN: user should be on test page and see a warning message
        _(page.warning_message.downcase).must_include 'seems like you did not answer all of the questions'
      end
    end
  end

  describe 'Click see result' do
    it '(HAPPY) redirect to suggestion page' do
      # WHEN: user click the button
      visit TestPage do |page|
        page.see_result
        # THEN: they should find themselves on the suggestion page
        @browser.url.include? 'suggestion'
      end
    end
  end
end
