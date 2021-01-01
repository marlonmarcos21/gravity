module CollectiveIdea
  module Acts
    module NestedSet
      def acts_as_nested_set_relate_parent!
        options = {
          class_name:    self.base_class.to_s,
          foreign_key:   parent_column_name,
          primary_key:   primary_column_name,
          counter_cache: acts_as_nested_set_options[:counter_cache],
          touch:         acts_as_nested_set_options[:touch]
        }

        if acts_as_nested_set_options[:polymorphic]
          options[:polymorphic] = true
        else
          options[:inverse_of] = :children
        end

        options[:optional] = true if ActiveRecord::VERSION::MAJOR >= 5

        belongs_to :parent, options
      end
    end
  end
end
