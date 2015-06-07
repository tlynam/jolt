class Sale < ActiveRecord::Base
  validates_presence_of :units, :first_name, :last_name, :address, :city, :zip,
    :country, :credit_card_number, :credit_card_date, :credit_card_ccv

  validates_numericality_of :units, :zip, :credit_card_number, :credit_card_ccv

  validate :check_cc_date

  after_create :update_sales_feed

  scope :unshipped, ->{ where shipped: false }
  scope :shipped, ->{ where shipped: true }

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

  def self.ship_sales
    unshipped.update_all(shipped: true)
  end

  def self.create_sale
    units = rand(1..25)
    first_name = %w(Todd Dave Morgan Rachel Jordan Lakshmi Amol Eberly Dan Janny).sample
    last_name = %w(Lynam Backus Liu Wedlake Muramoto Leong Lane).sample
    address = ['123 Water Rd', '2005 43rd Ave E', '9606 Wharf St', '5216 Ravenna Ave E',
              '4221 E Blaine St', 'One Boundary Lane'].sample
    address2 = [nil, 'Unit C', 'Apt 202'].sample
    city = ['Edmonds', 'Seattle', 'Santa Clara', 'San Jose', 'San Francisco'].sample
    zip = [98020, 98112, 98101, 95123, 95112].sample
    country = ['USA', 'Canada', 'China', 'Mexico', 'Sierra Leone', 'England'].sample
    cc_number = rand(100000000000000..999999999999999)
    cc_expiration = "#{rand(1..12)}/#{Date.today.year + rand(1..5)}"
    cc_ccv = rand(100..999)

    sale = Sale.new(units: units, first_name: first_name, last_name: last_name, address: address,
                    address2: address2, city: city, zip: zip, country: country,
                    credit_card_number: cc_number, credit_card_date: cc_expiration,
                    credit_card_ccv: cc_ccv)
    sale.save!
  end

  def update_sales_feed
    Pusher['sales_channel'].trigger('new_sale', {
      message: {
        units_sold: Sale.all.pluck(:units).sum,
        units_shipped: Sale.shipped.pluck(:units).sum,
        first_name: self.first_name,
        units: self.units,
        city: self.city,
        country: self.country,
        shipped: self.shipped
      }
    })
  end

end
