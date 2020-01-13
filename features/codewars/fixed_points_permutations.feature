Feature: Fixed Points Permutations
  For an array of unique elements,
  I want to return the number of special permutations,
  where special permutation are those that have the same element at a set number of fixed points


  Scenario Outline:
    Given I have an array that contains "<len>" elements
    And I want matching elements at "<i>" fixed points
    Then the number of special permutations should be "<permutations>"

    Examples:
    | len | i | permutations       |
    # | 4   | 1 | 8                  |
    # | 4   | 2 | 6                  |
    # | 4   | 3 | 0                  |
    # | 10  | 3 | 222480             |
    # | 10  | 4 | 55650              |
    # | 20  | 2 | 447507315596451070 |
    # | 4   | 0 | 9                  |
    # | 4   | 4 | 1                  |
    # | 4   | 5 | 0                  |
