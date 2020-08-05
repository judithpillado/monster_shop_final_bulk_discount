require 'rails_helper'

RSpec.describe 'As a Merchant Employee' do

  before :each do
    @merchant = create(:merchant)

    @merchant_employee = create(:user, role: 1, merchant_id: @merchant.id)

    @item1 = create(:item, merchant_id: @merchant.id)
    @item2 = create(:item, merchant_id: @merchant.id)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
  end

  it "I can create a new discount " do
    visit "/merchant/discounts/new"
    discount_percentage = 30
    minimum_quantity = 10
    fill_in :discount_percentage, with: discount_percentage
    fill_in :minimum_quantity, with: minimum_quantity

    click_button 'Create Discount'

    expect(current_path).to eq("/merchant/discounts")

    expect(page).to have_content("Discount: #{discount_percentage}%")
    expect(page).to have_content("Minimum Quantity: #{minimum_quantity} items")
  end

end
