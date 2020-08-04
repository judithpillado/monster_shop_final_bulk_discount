class Discount < ApplicationRecord

  validates_presence_of :discount_percentage, :minimum_quantity

  belongs_to :merchant

end
