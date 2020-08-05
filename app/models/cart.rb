class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def remove_item(item)
    @contents[item] -= 1
    @contents.delete(item) if @contents[item].zero?
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def subtotal(item)
    quantity = @contents[item.id.to_s]
    percentage = item.merchant.discounts.where("minimum_quantity <= ?", quantity).maximum(:discount_percentage)
    if percentage == nil
      item.price * quantity
    elsif
      (item.price * quantity) * (100 - percentage)/100.0
    end
  end

  def total
    total = 0
    items.each do |item, quantity|
      percentage = item.merchant.discounts.where("minimum_quantity <= ?", quantity).maximum(:discount_percentage)
      if percentage == nil
        total += item.price * quantity
      elsif
        total += (item.price * quantity) * (100 - percentage)/100.0
      end
    end
    total
  end

end
