@offline
Feature: CamelCase
  Write simple camelCase method.
  All words must have their first letter capitalized without spaces.
  For example,
  'hello case'.camelcase => HelloCase
  'camel case word'.camelcase => CamelCaseWord

  Scenario Outline:
    Given a standard string "<input_string>"
    Then camelcase should return "<output_string>"

  Examples:
  | input_string    | output_string |
  | hello case      | HelloCase     |
  | camel case word | CamelCaseWord |
