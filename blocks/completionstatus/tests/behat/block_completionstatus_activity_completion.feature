@block @block_completionstatus @core_completion
Feature: Enable Block Completion in a course using activity completion
  In order to view the completion block in a course
  As a teacher
  I can add completion block to a course and set up activity completion

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email | idnumber |
      | teacher1 | Teacher | 1 | teacher1@example.com | T1 |
      | student1 | Student | 1 | student1@example.com | S1 |
    And the following "courses" exist:
      | fullname | shortname | category | enablecompletion |
      | Course 1 | C1        | 0        | 1                |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | teacher1 | C1     | editingteacher |
      | student1 | C1     | student        |
    And the following "activities" exist:
      | activity   | course | idnumber   | name             | intro                 |
      | page       | C1     | page1      | Test page name   | Test page description |
      | assign     | C1     | assign1    | Test assign name | Test page description |

  Scenario: Add the block to a the course and add course completion items
    Given I log in as "teacher1"
    And I am on "Course 1" course homepage with editing mode on
    And I follow "Test page name"
    And I navigate to "Settings" in current page administration
    And I set the following fields to these values:
      | Add requirements         | 1                  |
      | View the activity | 1 |
    And I press "Save and return to course"
    And I add the "Course completion status" block
    And I navigate to "Course completion" in current page administration
    And I expand all fieldsets
    And I set the following fields to these values:
      | Test page name | 1 |
    And I press "Save changes"
    And I log out
    When I log in as "student1"
    And I am on "Course 1" course homepage
    Then I should see "Status: Not yet started" in the "Course completion status" "block"
    And I should see "0 of 1" in the "Activity completion" "table_row"

  Scenario: Add the block to a the course and add course completion items
    Given I log in as "teacher1"
    And I am on "Course 1" course homepage with editing mode on
    And I follow "Test page name"
    And I navigate to "Settings" in current page administration
    And I set the following fields to these values:
      | Add requirements         | 1                  |
      | View the activity | 1 |
    And I press "Save and return to course"
    And I add the "Course completion status" block
    And I navigate to "Course completion" in current page administration
    And I expand all fieldsets
    And I set the following fields to these values:
      | Test page name | 1 |
    And I press "Save changes"
    And I log out
    When I log in as "student1"
    And I am on "Course 1" course homepage
    And I follow "Test page name"
    And I am on "Course 1" course homepage
    Then I should see "Status: Complete" in the "Course completion status" "block"
    And I should see "1 of 1" in the "Activity completion" "table_row"
    And I follow "More details"
    And I should see "Yes" in the "Activity completion" "table_row"

  @javascript
  Scenario: Add the block to a the course and add course completion items with passing grade
    Given I am on the "Test assign name" "assign activity" page logged in as teacher1
    And I navigate to "Settings" in current page administration
    And I set the following fields to these values:
      | Add requirements | 1  |
      | Receive a grade  | 1  |
      | Passing grade    | 1  |
      | gradepass        | 50 |
    And I press "Save and return to course"
    And I am on the "Test assign name" "assign activity" page
    And I follow "View all submissions"
    And I click on "Grade" "link" in the "Student" "table_row"
    And I set the field "Grade out of 100" to "53"
    And I set the field "Notify student" to "0"
    And I press "Save changes"
    And I am on "Course 1" course homepage with editing mode on
    And I add the "Course completion status" block
    And I navigate to "Course completion" in current page administration
    And I expand all fieldsets
    And I set the following fields to these values:
      | Test assign name | 1 |
    And I press "Save changes"
    And I log out
    When I am on the "Test assign name" "assign activity" page logged in as student1
    And I am on "Course 1" course homepage
    Then I should see "Status: Pending" in the "Course completion status" "block"
    And I should see "0 of 1" in the "Activity completion" "table_row"
    And I trigger cron
    And I am on "Course 1" course homepage
    And I follow "More details"
    And I should see "Achieving grade, Achieving passing grade" in the "Activity completion" "table_row"
    And I should see "Yes" in the "Activity completion" "table_row"

  @javascript
  Scenario: Add the block to a the course and add course completion items with failing grade.
    Given I am on the "Test assign name" "assign activity" page logged in as teacher1
    And I navigate to "Settings" in current page administration
    And I set the following fields to these values:
      | Add requirements | 1  |
      | Receive a grade  | 1  |
      | Passing grade    | 1  |
      | gradepass        | 50 |
    And I press "Save and return to course"
    And I am on the "Test assign name" "assign activity" page
    And I follow "View all submissions"
    And I click on "Grade" "link" in the "Student" "table_row"
    And I set the field "Grade out of 100" to "49"
    And I set the field "Notify student" to "0"
    And I press "Save changes"
    And I am on "Course 1" course homepage with editing mode on
    And I add the "Course completion status" block
    And I navigate to "Course completion" in current page administration
    And I expand all fieldsets
    And I set the following fields to these values:
      | Test assign name | 1 |
    And I press "Save changes"
    And I log out
    When I am on the "Test assign name" "assign activity" page logged in as student1
    And I am on "Course 1" course homepage
    Then I should see "Status: Pending" in the "Course completion status" "block"
    And I should see "0 of 1" in the "Activity completion" "table_row"
    And I trigger cron
    And I am on "Course 1" course homepage
    And I follow "More details"
    And I should see "Achieving grade, Achieving passing grade" in the "Activity completion" "table_row"
    And I should see "No" in the "Activity completion" "table_row"
