@offline
Feature: Minecraft Furnace Fuel
  As a Minecraft railway ingot producer
  I want to calculate the minimum amount of fuel needed to keep the furnaces blazing
  So that I will produce ingots at the lowest expense

  Scenario Outline:
    Given I need to produce "<ingots>" ingots for my Minecraft railway
    Then I should need "<lava>" buckets of lava for the furnace
    And I should need "<blaze_rod>" blaze rods for the furnace
    And I should need "<coal>" lumps of coal for the furnace
    And I should need "<wood>" blocks of wood for the furnace
    And I should need "<stick>" sticks for the furnace

    Examples:
    | ingots | lava | blaze_rod | coal | wood | stick |
    | 37     | 0    | 3         | 0    | 3    | 2     |
    | 21     | 0    | 1         | 1    | 2    | 1     |
    | 123    | 1    | 4         | 0    | 4    | 13    |
