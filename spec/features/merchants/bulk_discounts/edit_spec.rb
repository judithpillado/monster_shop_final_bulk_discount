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

  it "I can edit a discount" do
    visit "/merchant/discounts/#{@discount1.id}/edit"
    discount_percentage = 20
    minimum_quantity = nil
    fill_in :discount_percentage, with: discount_percentage
    fill_in :minimum_quantity, with: minimum_quantity

    click_button 'Edit Discount'

    expect(current_path).to eq("/merchants/discounts/#{@discount1.id}")
    expect(page).to have_content("Discount: #{discount_percentage}%")
    expect(page).to have_content("Minimum Quantity: #{minimum_quantity} items")
  end

end
