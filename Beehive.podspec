Pod::Spec.new do |s|
  s.name = 'Beehive'
  s.version = '0.0.1'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.platform = :ios, '6.0'
  s.summary = "An Objective-C behaviour-driven development library."
  s.homepage = 'https://github.com/rdavies/Beehive'
  s.author = { 'Ryan Davies' => 'ryan@ryandavies.net' }
  s.source = { :git => 'https://github.com/rdavies/Beehive.git', :tag => '0.0.1' }
  s.source_files = 'Beehive/*.{h,m}'
  s.framework    = 'SenTestingKit'
  s.xcconfig     = { 'FRAMEWORK_SEARCH_PATHS' => '"$(SDKROOT)/Developer/Library/Frameworks" "$(DEVELOPER_LIBRARY_DIR)/Frameworks"' }
  s.requires_arc = true
end
