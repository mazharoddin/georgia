require 'active_support/concern'

module Georgia
  module Concerns
    module Orderable
      extend ActiveSupport::Concern

      included do

        acts_as_list
        attr_accessible :position

        scope :ordered, order(:position)

      end

      module ClassMethods
      end
    end
  end
end