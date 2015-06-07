class Sale < ActiveRecord::Base
  validates_presence_of :units, :first_name, :last_name, :address, :city, :zip,
    :country, :credit_card_number, :credit_card_date, :credit_card_ccv

  validates_numericality_of :units, :zip, :credit_card_number, :credit_card_ccv

  validate :check_cc_date

  def check_cc_date
    month_str, year_str = self.credit_card_date.split("/")[0],
                          self.credit_card_date.split("/")[1]
    begin
      month = Integer(month_str)
      year = Integer(year_str)
    rescue ArgumentError, TypeError
      return errors.add(:base, 'Credit Card Expiration Date must be valid numbers')
    end

    begin
      date = Date.new(year, month, 1).end_of_month
    rescue ArgumentError
      return errors.add(:base, 'Credit Card Expiration Date must be valid')
    end

    if date < Date.today
      return errors.add(:base, 'Credit Card Expiration Date must be current month or later')
    end
  end

end
