require 'rails_helper'

RSpec.describe 'As a registered user' do
  describe 'When I visit a show page for an order' do
      before :each do
        @user = create(:user)
        visit login_path
        fill_in :email, with: @user.email
        fill_in :password, with: @user.password
        click_button 'Log In'

        @items1 = create_list(:item, 5)
        @items1.each do |item|
          visit "/items/#{item.id}"
          click_on "Add To Cart"
        end

        visit cart_path
        click_on "Checkout"
        fill_in :name, with: @user.name
        fill_in :address, with: @user.address
        fill_in :city, with: @user.city
        fill_in :state, with: @user.state
        fill_in :zip, with: @user.zip
        click_on "Create Order"
        expect(Order.all.count).to eq(1)

        @items2 = create_list(:item, 3)
        @items2.each do |item|
          visit "/items/#{item.id}"
          click_on "Add To Cart"
        end

        visit cart_path
        click_on "Checkout"
        fill_in :name, with: @user.name
        fill_in :address, with: @user.address
        fill_in :city, with: @user.city
        fill_in :state, with: @user.state
        fill_in :zip, with: @user.zip
        click_on "Create Order"
        expect(Order.all.count).to eq(2)

        @order1 = Order.all.first
        @order2 = Order.all.last

        @orders = [@order1, @order2]

      end

    it "I can access the order show page by clicking on the order link from the order index page" do

      visit "/profile/orders"
      within("section.order-#{@order1.id}") do
        expect(page).to have_link("Order #{@order1.id}", href: "/profile/orders/#{@order1.id}")
      end

      click_on "Order #{@order1.id}"
      expect(current_path).to eq("/profile/orders/#{@order1.id}")

    end

    it "shows all order information, including order ID, order date, date of last update, current status" do
      visit "/profile/orders/#{@order1.id}"
      expect(page).to have_content("Info for Order # #{@order1.id}")
      expect(page).to have_content("Order Date: #{@order1.created_at}")
      expect(page).to have_content("Last Updated: #{@order1.updated_at}")
      expect(page).to have_content("Status: #{@order1.status}")
    end

    it "also shows each item in the order, including item name, description, thumbnail image, quantity, price and subtotal" do
      visit "/profile/orders/#{@order1.id}"
      within("section#item-#{@items1.first.id}") do
        expect(page).to have_content(@items1.first.name)
        expect(page).to have_content(@items1.first.description)
        expect(page).to have_css("img[src*='#{@items1.first.image}']")
        expect(page).to have_css("img[alt='Thumbnail Of: #{@items1.first.name}']")
        expect(page).to have_content(@order1.item_orders.items_in_order_quantity(@items1.first))
        expect(page).to have_content(@order1.item_orders.item_order_subtotal(@items1.first))
      end
    end

    it "also shows the total quantity of items in the order as well as the grand total of all items in that order" do
      visit "/profile/orders/#{@order1.id}"
      expect(page).to have_content("Total Items: #{@order1.items.sum('quantity')}")
      expect(page).to have_content("Grand Total: $500.00")
    end
  end
end

# RSpec.describe 'As a registered user when I visit a show page for an order' do
#
#   it "After I've placed an order to which a discount has been applied, the discount is reflected on that order show page." do
#     @user = create(:user)
#     visit login_path
#     fill_in :email, with: @user.email
#     fill_in :password, with: @user.password
#     click_button 'Log In'
#     @clothing_boutique = Merchant.create(name: "Elah's Boutique", address: '227 Skirt St.', city: 'Chicago', state: 'IL', zip: 60619)
#     @blouse = @clothing_boutique.items.create(name: "Blouse", description: "Soft pink chiffon blouse", price: 15, image: "https://m.media-amazon.com/images/I/71HraJAaF3L._SR500,500_.jpg", inventory: 15)
#     @discount1 = @clothing_boutique.discounts.create!(discount_percentage: 30, minimum_quantity: 5)
#     allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
#
#     visit "/items/#{@blouse.id}"
#     click_on "Add To Cart"
#     visit "/cart"
#     4.times do
#         click_button "Add 1"
#       end
#     visit orders_new_path
#     fill_in :name, with: @user.name
#     fill_in :address, with: @user.address
#     fill_in :city, with: @user.city
#     fill_in :state, with: @user.state
#     fill_in :zip, with: @user.zip
#     click_on "Create Order"
#     order = Order.last
#     visit "/profile/orders/#{order.id}"
#     # within("#item-#{@items1.id}") do
#     #   expect(page).to have_content("$375")
#     # end
#     expect(page).to have_content("Grand Total: $52.50")
#   end
# end
