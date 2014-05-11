Feature: Index page

In order to know all the details about the wedding
As a invited person
I want to reach the website first page

  Scenario: Invited person type the url
    When I go to the website first page
    Then I should see "wedding"

  Scenario: Invited person from Italy type the url
    When I go to the website first page
    Then I should see "matrimonio" 
