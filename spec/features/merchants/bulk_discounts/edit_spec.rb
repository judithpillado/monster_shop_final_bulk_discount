require 'rails_helper'

RSpec.describe 'As a Merchant Employee' do

  before :each do
    @merchant = create(:merchant)

    @merchant_employee = create(:user, role: 1, merchant_id: @merchant.id)

    @item1 = create(:item, merchant_id: @merchant.id)
    @item2 = create(:item, merchant_id: @merchant.id)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
  end

  # it "I can edit an existing discount " do
  #   visit "/merchant/discounts
  # end

end
