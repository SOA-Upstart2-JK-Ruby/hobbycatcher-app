# frozen_string_literal: true

require_relative '../../helpers/acceptance_helper'
require_relative 'pages/home_page'

describe 'Homepage Acceptance Tests' do
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

  describe 'Visit Home page' do
    it '(HAPPY) should see two buttons' do
      # WHEN: user visit the home page
      visit HomePage do |page|
        # THEN: they should see basic headers and two buttons
        _(page.navigation).must_equal 'HobbyCatcher'
        _(page.title).must_equal 'HobbyCatcher'
        _(page.text_content.present?).must_equal true
        _(page.catch_hobby_element.present?).must_equal true
        _(page.view_history_element.present?).must_equal true

        # _(page.success_message_element.present?).must_equal true
        # _(page.success_message.downcase).must_include 'start'
      end
    end
  end

  describe 'Click catch my hobby' do
    it '(HAPPY) redirect to test page' do
      # WHEN: user click the button
      visit HomePage do |page|
        page.catch_hobby
        # THEN: they should find themselves on the test page
        @browser.url.include? 'test'
      end
    end
  end
end
