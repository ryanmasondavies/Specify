PODFILE_CONTENTS = <<-EOF
platform :ios, '5.0'
target 'Specs' do
  pod 'Specify', :local => '../../../'
end
EOF

def write_podfile(path)
  podfile = File.open(path, "w")
  podfile.write PODFILE_CONTENTS
  podfile.close
end
