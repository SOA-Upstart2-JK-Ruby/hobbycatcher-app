# frozen_string_literal: true

require 'http'
require 'yaml'
require 'pry'
require 'delegate'

config = YAML.safe_load(File.read('config/secrets.yml'))

def ud_api_path(path)
  "https://www.udemy.com/api-2.0/courses/#{path}"
end

def call_ud_url(config, url)
  HTTP.headers('Accept' => 'application/json, text/plain, */*',
               'Authorization' => "Basic #{config['development']['UDEMY_TOKEN']}",
               'Content-Type' => 'application/json;charset=utf-8').get(url)
end

ud_response = {}
ud_results = {}

NEWLINE = "\n"

# HAPPY course list (clist) request
field = 'category'
keyword = 'Design'
clist_url = ud_api_path("?#{field}=#{keyword}&fields[course]=avg_rating,primary_category,image_240x135,price,title,url,id")
ud_response[clist_url] = call_ud_url(config, clist_url)
clist = ud_response[clist_url].parse

courses = clist['results']

## HAPPY course request
key = %w[id title url price image rating category]

ud_results = courses.map do |course|
  course_url = ud_api_path("#{course['id']}/?fields[course]=@all")
  ud_response[course_url] = call_ud_url(config, course_url)
  info = ud_response[course_url].parse

  value = info['id'], info['title'], "https://www.udemy.com#{course['url']}",
          info['price'], info['image_240x135'], info['avg_rating'],info['primary_category']
  key.zip(value).to_h
end

## BAD: wrong course request
bad_course_url = ud_api_path('WrongRequest')
ud_response[bad_course_url] = call_ud_url(config, bad_course_url)
ud_response[bad_course_url].parse

File.write('spec/fixtures/udemy_results.yml', ud_results.to_yaml)
