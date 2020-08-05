require 'rails_helper'

RSpec.describe 'As a Merchant Employee' do

  before :each do
    @merchant = create(:merchant)

    @merchant_employee = create(:user, role: 1, merchant_id: @merchant.id)

    @discount1 = @merchant.discounts.create!(discount_percentage: 20, minimum_quantity: 20, merchant: @merchant1)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
  end

  it "I see all of the discounts" do
    visit "/merchant/discounts"

    within("#discount-#{@discount1.id}") do
      expect(page).to have_link("Discount ##{@discount1.id}", href: "/merchant/discounts/#{@discount1.id}")
      expect(page).to have_content("Discount: #{@discount1.discount_percentage}%")
      expect(page).to have_content("Minimum Quantity: #{@discount1.minimum_quantity} items")
    end
  end

  it "I see a link to add a new discount " do
    visit "/merchant/discounts"

    click_link "Create a New Discount"
    expect(current_path).to eq("/merchant/discounts/new")
  end
end
