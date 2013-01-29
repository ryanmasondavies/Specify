TEMPLATE_PROJECT_DIRECTORY_NAME = 'Project'

def temporary_project_path
  File.join(@dirs[0], TEMPLATE_PROJECT_DIRECTORY_NAME)
end

def create_temporary_project
  FileUtils.mkdir_p(File.join(@dirs[0], TEMPLATE_PROJECT_DIRECTORY_NAME))
  FileUtils.cp_r(Dir["#{features_path}/Fixtures/#{TEMPLATE_PROJECT_DIRECTORY_NAME}/*"], "#{@dirs[0]}/#{TEMPLATE_PROJECT_DIRECTORY_NAME}")
end

def write_spec_for_temporary_project(content)
  f = File.open(File.join(@dirs[0], TEMPLATE_PROJECT_DIRECTORY_NAME, 'Specs', 'Specs.m'), "w")
  f.write content
  f.close
end
