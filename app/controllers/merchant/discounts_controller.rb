class Merchant::DiscountsController < ApplicationController

  def index
    @discounts = Discount.all
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def new
  end

end
