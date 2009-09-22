##
# Multiple Controller View Paths - Rails 2.0 only.
if (File.exists?(File.join(File.dirname(__FILE__), '../../../vendor/rails')) || RAILS_GEM_VERSION >= '1.2.5')
  ActionController::Base.view_paths.unshift File.join(directory, 'views')
end
