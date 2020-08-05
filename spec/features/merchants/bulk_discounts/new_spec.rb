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

  it "I can't create a discount if I don't fill out the discount percentage field" do

    visit "/merchant/discounts/new"
    discount_percentage = nil
    minimum_quantity = 10
    fill_in :discount_percentage, with: discount_percentage
    fill_in :minimum_quantity, with: minimum_quantity

    click_button 'Create Discount'

    expect(current_path).to eq(merchant_discounts_path)

    expect(page).to have_content("Discount percentage can't be blank")
    # expect(page).to have_field(:minimum_quantity, with: minimum_quantity)
  end

  it "I can't create a discount if I don't fill out the minimum quantity field" do

    visit "/merchant/discounts/new"
    discount_percentage = 20
    minimum_quantity = nil
    fill_in :discount_percentage, with: discount_percentage
    fill_in :minimum_quantity, with: minimum_quantity

    click_button 'Create Discount'

    expect(current_path).to eq(merchant_discounts_path)

    expect(page).to have_content("Minimum quantity can't be blank")
    # expect(page).to have_selector("input[value='discount_percentage']")
  end

end
