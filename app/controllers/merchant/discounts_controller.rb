class Merchant::DiscountsController < ApplicationController

  def index
    @discounts = Discount.all
  end

  def new
    @discount = Discount.new
  end

  def create
    merchant = current_user.merchant
    @discount = merchant.discounts.new(discount_params)
    if @discount.save
      flash[:success] = "Added #{@discount.id} to discount list"
      redirect_to "/merchant/discounts"
    else
      flash[:error] = @discount.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def discount_params
    params.permit(:discount_percentage, :minimum_quantity)
  end

end
