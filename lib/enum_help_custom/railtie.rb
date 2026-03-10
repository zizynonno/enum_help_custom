module EnumHelpCustom
  class Railtie < Rails::Railtie
    initializer "enum_help_custom.include_into_active_record" do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.prepend(EnumHelpCustom::EnumExtension)
      end
    end
  end
end
