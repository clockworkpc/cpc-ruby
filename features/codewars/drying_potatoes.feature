@offline
Feature: Drying Potatoes
  I want to calculate the weight of dried potatoes

Scenario Outline:
  Given the potato water ratio is "<initial_water_percent>" percent
  And the potato weight is "<initial_weight>" kilograms
  When the potato water ratio changes to "<final_water_percent>" percent
  Then the potato weight should be "<final_weight>" kilograms

  Examples:
  | initial_water_percent | initial_weight | final_water_percent | final_weight |
  | 82                    | 127            | 80                  | 114          |
  | 99                    | 100            | 98                  | 50           |
