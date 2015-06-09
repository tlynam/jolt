require "minitest_helper"

class SalesControllerTest < ActionController::TestCase
  def setup
    @sale   =  Sale.create!(units:                   5,
                            first_name:              "Todd",
                            last_name:               "Lynam",
                            address:                 "123 Water Rd",
                            city:                    "Seattle",
                            country:                 "USA",
                            credit_card_number:      2785927402749501,
                            credit_card_date:        "10/2018",
                            credit_card_ccv:         123)
  end

  def test_index
    get :index
    assert_response :success
    assert_equal('Jolt Cola Sales',   assigns(:title))
    assert_match @sale.first_name,    @response.body
  end

  def test_new
    get :new
    assert_response :success

    assert_equal('Purchase Your Jolt Cola',   assigns(:title))
    assert_select "input#sale_first_name"
    assert_select "input#sale_units"
    assert_select "input#sale_city"
  end

  def test_create
    assert_difference('Sale.count', 1) do
      post :create, sale:    {units:                   25,
                              first_name:              "Test",
                              last_name:               "Name",
                              address:                 "123 Water Rd",
                              city:                    "Seattle",
                              country:                 "USA",
                              credit_card_number:      2785927402749501,
                              credit_card_date:        "10/2018",
                              credit_card_ccv:         123}
    end

    assert_redirected_to sales_path
    get :index
    assert_response :success
    assert_match @sale.first_name,        @response.body
  end

end
