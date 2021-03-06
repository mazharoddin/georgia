module Georgia
  class Menu < ActiveRecord::Base

    validates :name, presence: true

    has_many :links, -> { order(position: :asc) }, dependent: :destroy
    accepts_nested_attributes_for :links, allow_destroy: true

    def self.policy_class
      Georgia::NavigationPolicy
    end
  end
end