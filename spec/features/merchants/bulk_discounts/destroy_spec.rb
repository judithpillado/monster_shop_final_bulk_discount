require 'rails_helper'

RSpec.describe 'As a Merchant Employee' do

  before :each do
    @merchant = create(:merchant)

    @merchant_employee = create(:user, role: 1, merchant_id: @merchant.id)

    @item1 = create(:item, merchant_id: @merchant.id)
    @item2 = create(:item, merchant_id: @merchant.id)

    @discount1 = @merchant.discounts.create!(discount_percentage: 20, minimum_quantity: 20, merchant: @merchant1)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
  end

  it "I can delete a discount" do
    visit "/merchant/discounts"

    within("#discount-#{@discount1.id}") do
      click_link "Delete Discount"
    end

    expect(current_path).to eq("/merchant/discounts")
    expect(page).to_not have_content("Discount ##{@discount1.id}")
    
  end

end
