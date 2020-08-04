require 'rails_helper'

RSpec.describe 'As a Merchant Employee' do

  before :each do
    @merchant = create(:merchant)
    @merchant2 = create(:merchant)

    @merchant_employee = create(:user, role: 1, merchant_id: @merchant.id)
    # visit '/login'
    # fill_in :email, with: @merchant_employee.email
    # fill_in :password, with: @merchant_employee.password
    # click_button 'Log In'

    @item1 = create(:item, merchant_id: @merchant.id)
    @item2 = create(:item, merchant_id: @merchant.id)

    @item3 = create(:item, merchant_id: @merchant2.id)
    @item4 = create(:item, merchant_id: @merchant2.id)

    @discount1 = @merchant.discounts.create!(discount_percentage: 20, minimum_quantity: 20, merchant: @merchant1)
    @discount2 = @merchant2.discounts.create!(discount_percentage: 50, minimum_quantity: 30, merchant: @merchant2)
  end

  it "displays all of the discounts" do

    visit "/merchant/discounts"

    # expect(page).to have_content("Discount ##{@discount1.id}")
    expect(page).to have_content("Discount: #{@discount1.discount_percentage}%")
    expect(page).to have_content("Minimum Quantity: #{@discount1.minimum_quantity} items")
  end

end
