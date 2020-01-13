@offline
Feature: Word Order Sorting
  I want to sort words by the integers inside them

  Scenario Outline: Words with numbers inside them
    When I input the jumbled words "<jumbled_words>"
    Then the jumbled words should be sorted like this "<sorted_words>"

    Examples:
    | jumbled_words                    | sorted_words                     |
    | is2 Thi1s T4est 3a               | Thi1s is2 3a T4est               |
    | 4of Fo1r pe6ople g3ood th5e the2 | Fo1r the2 g3ood 4of th5e pe6ople |
    |                               |                               |
