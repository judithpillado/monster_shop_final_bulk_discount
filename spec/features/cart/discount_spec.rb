require 'rails_helper'

RSpec.describe "As a User" do
  before(:each) do
    @clothing_boutique = Merchant.create(name: "Elah's Boutique", address: '227 Skirt St.', city: 'Chicago', state: 'IL', zip: 60619)
    # @shoe_store = Merchant.create(name: "Sinai's Shoe Store", address: '1211 Boot St.', city: 'Chicago', state: 'IL', zip: 60638)

    @blouse = @clothing_boutique.items.create(name: "Blouse", description: "Soft pink chiffon blouse", price: 15, image: "https://m.media-amazon.com/images/I/71HraJAaF3L._SR500,500_.jpg", inventory: 15)
    @skirt = @clothing_boutique.items.create(name: "Maxi Skirt", description: "Multi-colored a-line maxi skirt", price: 30, image: "https://cache.net-a-porter.com/images/products/1104844/1104844_ou_2000_q80.jpg", inventory: 30)
    @pijamas = @clothing_boutique.items.create(name: "PJs", description: "Warm pjs for the winter", price: 20, image: "https://www.zaflynn.com/33088-large_default/women-s-pajamas-cotton-flannel-hoodie-winter-warm-sleepwear-set-c61805stkuh.jpg", inventory: 20)

    @user = User.create(name: "Jane Doe", address: "123 Palm St", city: "Chicago", state: "IL", zip: 60623, email: "janedoe@email.com", password: "password", password_confirmation: "password")
    @merchant_employee1 = User.create(name: "Samaria Pillado", address: "456 Cool St", city: "Chicago", state: "IL", zip: 60619, email: "samaria@email.com", password: "password", password_confirmation: "password", role: 1)
    @merchant_employee2 = User.create(name: "Cloe Pillado", address: "456 Cool St", city: "Chicago", state: "IL", zip: 60619, email: "cloe@email.com", password: "password", password_confirmation: "password", role: 1)

    @discount1 = @clothing_boutique.discounts.create!(discount_percentage: 30, minimum_quantity: 5)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

  end

  it "displays the discount when I add the minimum quantity to my cart" do
    visit "/items/#{@blouse.id}"
    click_on "Add To Cart"
    visit "/cart"
    expect(page).to have_content("Total: $15.00")

    4.times do
      click_button "Add 1"
    end
    # total = @blouse.price * 5
    # percentage = @discount1.discount_percentage * 0.01
    expect(page).to have_content("Total: $75.00")
  end

  it "displays the discount only for the item that's on sale, not all the items from the same merchant" do
    visit "/items/#{@blouse.id}"
    click_on "Add To Cart"
    visit "/cart"

    4.times do
      click_button "Add 1"
    end

    visit "/items/#{@skirt.id}"
    click_on "Add To Cart"
    visit "/cart"

    expect(page).to have_content("Total: $105.00")
  end

  it "if I add many DIFFERENT items in my cart that meet the minimum quantity but don't meet the sale SINGLE item minimum quantity, there is no discount" do
    visit "/items/#{@blouse.id}"
    click_on "Add To Cart"
    visit "/cart"

    2.times do
      click_button "Add 1"
    end

    visit "/items/#{@skirt.id}"
    click_on "Add To Cart"
    visit "/cart"

    visit "/items/#{@pijamas.id}"
    click_on "Add To Cart"
    visit "/cart"

    expect(page).to have_content("Total: $95.00")
  end
end
