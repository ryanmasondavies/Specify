def build_path
  File.join(features_path, 'tmp', 'build')
end

def build_commands
  builds = [
    { "project" => "Pods/Pods.xcodeproj", "target" => "Pods-Specs" },
    { "project" => "Project.xcodeproj",   "target" => "Specs" }
  ]
  builds.map do |build|
    "xcodebuild -project #{build["project"]} -target #{build["target"]} -configuration Debug -sdk iphonesimulator6.0 SYMROOT=#{build_path} clean build"
  end
end
