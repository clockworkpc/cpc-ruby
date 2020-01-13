  Feature: Jekyll Placer
  In order to have Jekyll display HTML reports
  I want to copy all the HTML reports from Concordion to Jekyll

  Scenario: HTML and CSS Reports generated
    Given HTML reports with CSS are generated in "spec/fixtures/ruby_2_6_5_core"
    And the target folder is "spec/fixtures/jekyll/_posts"
    And the temp folder is "spec/output/jekyll_tmp"
    When the files in the temp folder are recursively deleted
    And a datestamp has been generated
    And the report files are recursively copied from source to temp
    And the "html" basenames are prepended with a datestamp
    And the "css" basenames are prepended with a datestamp
    And all files not prepended with a datestamp are deleted from the temp folder
    And all the empty folders are deleted from the temp folder
    Then the datestamped HTML and CSS files should be recursively copied from temp to target
