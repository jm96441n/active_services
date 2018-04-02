module ActiveServices
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../../../templates', __FILE__)
      desc 'Creates ActiveService abstract class for your Service Objects to inherit from.'

      def copy_template
        template 'active_service_template.rb', 'app/services/active_service.rb'
        puts 'Install complete! To start making your own service objects run the INSERT GENERATOR HERE to start making your own'
      end
    end
  end
end
