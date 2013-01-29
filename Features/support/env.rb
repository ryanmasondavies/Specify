require 'aruba/cucumber'

def features_path
  File.join(Dir.pwd, 'Features')
end

Before do
  @aruba_timeout_seconds = 10 # ?
  @dirs = [File.join(features_path, 'tmp')]
end

After do
  FileUtils.rm_rf(@dirs[0])
end
