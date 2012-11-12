Given /^the spec:$/ do |content|
  spec_file = File.join(@dirs[0], 'Specs', 'Spec.m')
  code = <<-EOF
  #import "BHVSpec.h"
  
  SpecBegin(Basic)
  
  #{content}
  
  SpecEnd
EOF

  File.open(spec_file, "w") do |f|
    f.write(code)
  end
end

When /^I run the spec$/ do
  step "I run `xcodebuild -target Specs -sdk iphonesimulator6.0 -configuration Debug clean build`"
end
