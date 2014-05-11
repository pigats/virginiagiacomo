require 'rspec'
require_relative '../../virginiaegiacomo.rb'



When(/^I go to the website first page$/) do
  a = VirginiaGiacomo.new
  a.get('/')
end

Then(/^I should see "(.*?)"$/) do |arg1|
  expect(page).to match('wedding')
end