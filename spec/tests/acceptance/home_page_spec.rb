# frozen_string_literal: true

require_relative '../../helpers/acceptance_helper'
require_relative 'pages/home_page'

describe 'Homepage Acceptance Tests' do
  include PageObject::PageFactory

  before do
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    # DatabaseHelper.wipe_database
    @browser = Watir::Browser.new :chrome, options: options
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
        _(page.homepage_title).must_equal 'Hobby Catcher'
        _(page.catch_hobby_element.present?).must_equal true
        _(page.view_history_element.present?).must_equal true
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

  describe 'Click catch my history' do
    it '(HAPPY) redirect to history page' do
      # WHEN: user click the button
      visit HomePage do |page|
        page.view_history
        # THEN: they should find themselves on the history page
        @browser.url.include? 'history'
      end
    end
  end
end
