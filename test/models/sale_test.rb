require "minitest_helper"

class SaleTest < ActiveSupport::TestCase
  def test_sale_must_have_purchase_information
    sale        =  Sale.new(units:                   5,
                            first_name:              "Todd",
                            last_name:               "Lynam",
                            address:                 "123 Water Rd",
                            city:                    "Seattle",
                            country:                 "USA",
                            credit_card_number:      2785927402749501,
                            credit_card_date:        "10/2018",
                            credit_card_ccv:         123)

    assert sale.valid?

    invalid     =  Sale.new(country:                 "France",
                            first_name:              "Todd",
                            last_name:               "Lynam",
                            address:                 "123 Water Rd")
    refute invalid.valid?
  end

  def test_sale_credit_card_date_format_with_leading_0
    sale        =  Sale.new(units:                   5,
                            first_name:              "Todd",
                            last_name:               "Lynam",
                            address:                 "123 Water Rd",
                            city:                    "Seattle",
                            country:                 "USA",
                            credit_card_number:      2785927402749501,
                            credit_card_date:        "09/2018",
                            credit_card_ccv:         123)

    assert sale.valid?
  end
end
