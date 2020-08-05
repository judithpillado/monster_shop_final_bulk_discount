require 'rails_helper'

RSpec.describe 'As a Merchant Employee' do

  before :each do
    @merchant = create(:merchant)
    @merchant2 = create(:merchant)

    @merchant_employee = create(:user, role: 1, merchant_id: @merchant.id)

    @item1 = create(:item, merchant_id: @merchant.id)
    @item2 = create(:item, merchant_id: @merchant.id)

    @item3 = create(:item, merchant_id: @merchant2.id)
    @item4 = create(:item, merchant_id: @merchant2.id)

    @discount1 = @merchant.discounts.create!(discount_percentage: 20, minimum_quantity: 20, merchant: @merchant1)
    @discount2 = @merchant2.discounts.create!(discount_percentage: 50, minimum_quantity: 30, merchant: @merchant2)
  end

  it "I can create a new discount " do
    visit "/merchant/discounts/new"

    fill_in :discount_percentage, with: 30
    fill_in :minimum_quantity, with: 10

    click_button 'Create Discount'

    expect(current_path).to eq("/merchant/discounts")

    expect(page).to have_content("Discount: 30%")
    expect(page).to have_content("Minimum Quantity: 5 items")
  end

end
