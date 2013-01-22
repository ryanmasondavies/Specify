Pod::Spec.new do |s|
  s.name = 'Behave'
  s.version = '0.0.1'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.platform = :ios, '5.0'
  s.summary = "An Objective-C behaviour-driven development library."
  s.homepage = 'https://github.com/rdavies/Behave'
  s.author = { 'Ryan Davies' => 'ryan@ryandavies.net' }
  s.source = { :git => 'https://github.com/rdavies/Behave.git', :tag => '0.0.1' }
  s.source_files = 'Behave/*.{h,m}'
  s.framework    = 'SenTestingKit'
  s.xcconfig     = { 'FRAMEWORK_SEARCH_PATHS' => '"$(SDKROOT)/Developer/Library/Frameworks" "$(DEVELOPER_LIBRARY_DIR)/Frameworks"' }
  s.requires_arc = true
end
