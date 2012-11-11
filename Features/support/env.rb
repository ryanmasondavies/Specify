require 'aruba/cucumber'

Before do
  @dirs = [File.join(Dir.pwd, 'Features', 'tmp')]
  FileUtils.mkdir(@dirs[0])
  FileUtils.cp_r(Dir["#{Dir.pwd}/Features/Fixtures/*"], @dirs[0])
end

After do
  FileUtils.rm_rf(@dirs[0])
end
