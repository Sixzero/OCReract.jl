Feature: Execute OCReract to get text from images correctly
    As a developer
    I want to use OCReract functions in a Julia program
    In order to get the correct text from input images 

    Scenario: Use OCReract with an image loaded from disk
        Given a valid path to an input image
        And a valid path to an output text file
        When I run OCReract with an image in disk
        Then the text is correctly extracted

    Scenario: Use OCReract with an image loaded in memory
        Given a valid path to an input image
        When I run OCReract with an image in memory
        Then the text is correctly extracted

    Scenario: Write output over an existing text file
        Given a valid path to an input image
        And a valid path to an output text file
        When I run OCReract with an image in disk twice
        Then a warning is thrown about existing text file
        And the text is correctly extracted

    Scenario: Bad language
        Given a valid path to an input image
        And a valid path to an output text file
        And an invalid language
        When I run OCReract with an image in disk
        Then the result is false