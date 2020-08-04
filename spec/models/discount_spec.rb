require 'rails_helper'

RSpec.describe Discount do

  describe 'validations' do
    it {should validate_presence_of :discount_percentage}
    it {should validate_presence_of :minimum_quantity}
  end

  describe 'relationships' do
    it {should belong_to :merchant}
  end


end
