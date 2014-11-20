Feature: Multiple logging services

    Background:
        Given I start cocaine-runtime with "/functional/features/logging/cocaine.conf" config

    Scenario: Send testing message to non-core logger service
        Given I create "logging-optional" service and send "message" with 1 verbosity
        Then I should see "[INFO]: message" in file "/var/log/cocaine-optional.log"

