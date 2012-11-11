Given /^a test suite$/ do
  step "a directory named \"Project\""
  FileUtils.cp_r(Dir["#{features_path}/Fixtures/Project/*"], "#{@dirs[0]}/Project")
end

Given /^the spec:$/ do |content|
  f = File.open(File.join(@dirs[0], 'Project', 'Specs', 'Spec.m'), "w")
  f.write <<-EOF
#import <SenTestingKit/SenTestingKit.h>

@interface Spec : SenTestCase
@end

@implementation Spec

#{content}

@end
EOF
end

When /^I run the tests$/ do
  command = "xcodebuild -target Specs -configuration Debug -sdk iphonesimulator6.0 TEST_AFTER_BUILD=YES clean build"
  step "I cd to \"Project\""
  step "I run `#{command}`"
end
