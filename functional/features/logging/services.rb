require 'cocaine'

Given(/^I start cocaine\-runtime with "(.*?)" config$/) do |config|
  cmd = "/usr/bin/cocaine-runtime --config #{config} > /dev/null"
  @pid = spawn(cmd)
  sleep 1.0
end

Given(/^I create "(.*?)" service and send "(.*?)" with (\d) verbosity$/) do |name, message, level|
  Celluloid.logger = nil  
  Cocaine::LOG.level = Logger::ERROR

  service = Cocaine::Service.new name
  service.emit level.to_i, 'testing/functional', message
end

Then(/^I should see "(.*?)" in file "(.*?)"$/) do |output, path|
  Process.kill('TERM', @pid)
  
  File.open(path) do |file|
    c = file.readlines
    assert [output.to_s + "\n"] == c
  end
end
