require 'rails_helper'

describe ItemOrder, type: :model do
  describe "validations" do
    it { should validate_presence_of :order_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :price }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :status }
  end

  describe "relationships" do
    it {should belong_to :item}
    it {should belong_to :order}
  end

  describe "status" do
    before :each do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      customer = create(:user)
      order_1 = customer.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      @unfulfilled_item_order = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2, status: 0)
      @fulfilled_item_order = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2, status: 1)
    end

    it "can be unfulfilled" do
      expect(@unfulfilled_item_order.status).to eq("unfulfilled")
      expect(@unfulfilled_item_order.unfulfilled?).to be_truthy
    end

    it "can be fulfilled" do
      expect(@fulfilled_item_order.status).to eq("fulfilled")
      expect(@fulfilled_item_order.fulfilled?).to be_truthy
    end
  end

  describe 'instance methods' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @customer = create(:user)
      @order_1 = @customer.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      @item_order_1 = @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
    end

    it 'subtotal' do
      expect(@item_order_1.subtotal).to eq(200)
    end

    it "can_fulfill?" do
      order1 = create(:order)
      item1 = create(:item, inventory: 10)

      item_order1 = order1.item_orders.create(item: item1, price: item1.price, quantity: 1)
      expect(item_order1.can_fulfill?).to be_truthy

      item_order2 = order1.item_orders.create(item: item1, price: item1.price, quantity: item1.inventory)
      expect(item_order2.can_fulfill?).to be_truthy

      item_order3 = order1.item_orders.create(item: item1, price: item1.price, quantity: (item1.inventory + 1))
      expect(item_order3.can_fulfill?).to be_falsey
    end

    it "fulfill" do
      expect(@tire.inventory).to eq(12)
      expect(@item_order_1.status).to eq("unfulfilled")

      @item_order_1.fulfill
      expect(@tire.inventory).to eq(10)
      expect(@item_order_1.status).to eq("fulfilled")
    end

    it "unfulfill" do
      expect(@tire.inventory).to eq(12)

      @item_order_1.fulfill
      expect(@tire.inventory).to eq(10)

      @item_order_1.unfulfill
      expect(@tire.inventory).to eq(12)
      expect(@item_order_1.status).to eq("unfulfilled")
    end
  end

  describe 'class methods' do
    before :each do
      @user = create(:user)
      @item1 = create(:item)
      @item2 = create(:item)
      @order = create(:order)
      @user.orders << @order
      @item1.item_orders.create(order: @order, price: @item1.price, quantity: 2)
      @item2.item_orders.create(order: @order, price: @item1.price, quantity: 5)
    end

    it '.select_items_in_order(order)' do
      expect(ItemOrder.select_items_in_order(@item1)).to eq([@item1.item_orders.first])
    end

    it '.items_in_order_quantity' do
      expect(ItemOrder.items_in_order_quantity(@item1)).to eq(2)
    end

    it '.item_order_subtotal' do
      expect(ItemOrder.item_order_subtotal(@item1)).to eq(@item1.price * @order.item_orders.items_in_order_quantity(@item1))
    end

    it '.all_subtotal' do
      expect(ItemOrder.all_subtotal).to eq(700.0)
    end

    it '.pending_orders' do
      expect(ItemOrder.pending_orders).to eq(ItemOrder.joins(:order).select('orders.*').where(orders: {status: "1"}).distinct)
    end
  end
end
