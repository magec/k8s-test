Puppet::Functions.create_function(:'project_path') do
  dispatch :project_path do
    param 'String', :relative_path
  end

  def project_path(relative_path)
    scope = closure_scope
    File.expand_path(File.join(scope['facts']['project_home'], relative_path))
  end
end
