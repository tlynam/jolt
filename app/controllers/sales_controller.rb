class SalesController < ApplicationController

  def index
    @sales = Sale.all
  end

  def new
    @sale = Sale.new
  end

  def create
    @sale = Sale.new sale_params

    if @sale.save
      redirect_to sales_path, notice: 'Thank you for purchases Jolt Cola.  Feel the excitement!'
    else
      render 'new'
    end
  end

  private
  def sale_params
    params.require(:sale).permit :id, :units, :first_name, :last_name, :address,
      :address2, :city, :zip, :country, :credit_card_number, :credit_card_date,
      :credit_card_ccv
  end
end
