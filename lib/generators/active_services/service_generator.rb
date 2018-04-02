class ServiceGenerator < Rails::Generators::Base
  source_root File.expand_path('../../../templates', __FILE__)
  desc 'Generates a new service object to use'

  argument :model, type: :string
  argument :service, type: :string

  def copy_template
    template 'service_object_template.rb', "app/services/#{model.underscore}/#{service.underscore}.rb"
  end
end
