@online_extra
Feature: ISBN Fetcher
  In order to put together a list of books for sale
  I want to fetch the details of books via their ISBNs from ISBNdb

  Scenario Outline: ISBN Numbers Provided
    Given the box title is "<box>"
    And I make an API call to "ISBNdb" with "<isbn>"
    And the API response code is "200"
    When I parse the API response body and write it to "ISBN CSV"
    Then I should have a copy of the response body in a CSV
    And in the API response the box title should be "<box>"
    And in the API response the long title of the book should be "<long_title>"
    And in the API response the the author of the book should be "<author>"
    And in the API response the the publisher of the book should be "<publisher>"
    And in the API response the the binding of the book should be "<binding>"
    And in the API response the the book should have "<pages>" pages
    And in the API response the the publication date of the book should be "<date_published>"

    Examples:
    | isbn          | box                 | long_title             | author         | publisher                                     | binding      | pages | date_published |
    | 9781931499651 | 01 Craft            | Knitting Vintage Socks | Nancy Bush     | Interweave                                    | Spiral-bound | 128   | 2005           |
    | 9781596688513 | 02 Craft            | Scottish Knits         | Storey, Martin | Interweave Press,                                   | N/A    | N/A   | 2012           |
    | 9780957740358 | 04 Children's Books | Eye_spy_who_am_i       | N/A            | Melbourne : Borghesi & Adam Publishers, 2001. | N/A          | N/A   | N/A            |
