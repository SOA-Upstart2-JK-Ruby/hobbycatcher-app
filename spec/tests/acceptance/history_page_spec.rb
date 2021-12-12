# frozen_string_literal: true

require_relative '../../helpers/acceptance_helper'
require_relative 'pages/history_page'
require_relative 'pages/home_page'

describe 'History Page Acceptance Tests' do
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

  it '(HAPPY) should see history if it exists' do
    # GIVEN: user has taken the test at least once
    visit HomePage do |page|
      page.catch_hobby
    end

    # WHEN: user goes to the history page
    visit HistoryPage do |page|
      # THEN: they should see the history details
      _(page.history_table_element.present?).must_equal true
    end
  end

  describe 'Delete History' do
    it '(HAPPY) should be able to delete a history' do
      # GIVEN: user has taken the test at least once
      visit HomePage do |page|
        page.catch_hobby
      end

      # WHEN: user goes to the history page and delete the record
      visit HistoryPage do |page|
        page.first_project_delete

        # THEN: they should not find the record that has been deleted
        _(page.first_hobby_row.exists?).must_equal false
      end
    end
  end
end
