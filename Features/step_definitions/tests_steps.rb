Given /^I have a spec suite$/ do
  create_temporary_project
end

Given /^the spec suite has the spec:$/ do |content|
  write_spec_for_temporary_project(content)
end

When /^I run the specs$/ do
  step "I cd to \"Project\""
  build_commands.each {|command| step "I run `#{command}`"}
  step "I cd to \"..\""
end

Then /^the following examples should have passed:$/ do |table|
  table.hashes.each do |result|
    step "the output should contain \"Test Case '#{result["name"]}' passed\""
  end
end

Then /^the following examples should have failed:$/ do |table|
  table.hashes.each do |result|
    step "the output should contain \"Test Case '#{result["name"]}' failed\""
  end
end

Then /^there should have been no failures$/ do
  step "the output should match /Executed . tests, with 0 failures/"
end
