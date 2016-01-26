Feature: It works
  Scenario: Customize Crawler / Processor
    Given I have the "simple" application
    When I run crawler & processor
    Then processor receives the following message:
    """
    It works with 'http://example.com/'
    """
