Given /^I have added Specify as a dependency using CocoaPods$/ do
  write_podfile(File.join(temporary_project_path, 'Podfile'), ["Specify"])
end

Given /^I have added Specify and Expecta as dependencies using CocoaPods$/ do
  write_podfile(File.join(temporary_project_path, 'Podfile'), ["Specify", "Expecta"])
end

Given /^I have successfully installed the pods$/ do
  step "I cd to \"Project\""
  step "I successfully run `pod install`"
  step "I cd to \"..\""
end
