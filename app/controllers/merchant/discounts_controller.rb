class Merchant::DiscountsController < ApplicationController

  def index
    @discounts = Discount.all
  end

  def new
  end

end
