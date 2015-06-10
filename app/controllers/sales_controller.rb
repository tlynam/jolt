class SalesController < ApplicationController

  def index
    @title = 'Jolt Cola Sales'
    @sales = Sale.all
    @hash = Gmaps4rails.build_markers(@sales) do |sale, marker|
      marker.lat sale.latitude
      marker.lng sale.longitude
    end
  end

  def new
    @title = 'Purchase Your Jolt Cola'
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

  def simulate
    SimulateSalesJob.perform_later
    redirect_to sales_path
  end

  def delete_all
    Sale.all.delete_all
    redirect_to sales_path
  end

  private
  def sale_params
    params.require(:sale).permit :id, :units, :first_name, :last_name, :address,
      :address2, :city, :zip, :country, :credit_card_number, :credit_card_date,
      :credit_card_ccv
  end
end
