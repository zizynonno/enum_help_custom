module EnumHelpCustom
  module EnumExtension
    def enum(*args, **kwargs)
      before = defined_enums.keys.to_set
      super
      after = defined_enums.keys.to_set

      (after - before).each { |attr_name| _define_enum_i18n_methods(attr_name) }
    end

    private

    def _define_enum_i18n_methods(attr_name)
      # インスタンスメソッド: xxx_i18n
      # 例: user.status_i18n => "有効"
      define_method(:"#{attr_name}_i18n") do
        value = public_send(attr_name)
        return nil if value.nil?

        model_key = self.class.to_s.underscore.gsub("/", ".")
        I18n.t("enums.#{model_key}.#{attr_name}.#{value}", default: value.humanize)
      end

      # クラスメソッド: xxxs_i18n (一覧)
      # 例: User.statuses_i18n => { "active" => "有効", "inactive" => "無効" }
      define_singleton_method(:"#{attr_name.pluralize}_i18n") do
        model_key = to_s.underscore.gsub("/", ".")
        public_send(attr_name.pluralize).each_with_object({}.with_indifferent_access) do |(label, _), hash|
          hash[label] = I18n.t("enums.#{model_key}.#{attr_name}.#{label}", default: label.humanize)
        end
      end
    end
  end
end
