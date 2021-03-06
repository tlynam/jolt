class Sale < ActiveRecord::Base
  validates_presence_of :units, :first_name, :last_name, :address, :city,
    :country, :credit_card_number, :credit_card_date, :credit_card_ccv

  validates_numericality_of :units, :credit_card_number, :credit_card_ccv

  validate :check_cc_date

  after_create :update_sales_feed

  scope :unshipped, ->{ where shipped: false }
  scope :shipped, ->{ where shipped: true }

  geocoded_by :build_address
  after_validation :geocode

  def build_address
    [self.city, self.state, self.country].compact.join(', ')
  end

  def check_cc_date
    if self.credit_card_date == nil
      return errors.add(:base, 'Credit Card Expiration Date must be valid numbers')
    end

    month_str, year_str = self.credit_card_date.split("/")[0],
                          self.credit_card_date.split("/")[1]
    month_str = month_str[1] if month_str[0] == "0"

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

  def self.create_sale
    units = rand(1..25)
    first_name = %w(Todd Dave Morgan Rachel Jordan Lakshmi Amol Eberly Dan Janny).sample
    last_name = %w(Lynam Backus Liu Wedlake Muramoto Leong Lane).sample
    address = ['123 Water Rd', '2005 43rd Ave E', '9606 Wharf St', '5216 Ravenna Ave E',
              '4221 E Blaine St', 'One Boundary Lane'].sample
    address2 = [nil, 'Unit C', 'Apt 202'].sample
    zip = [98020, 98112, 98101, 95123, 95112].sample

    #data for maps
    city_data = [
      ['Edmonds', 'USA', 'Washington'],
      ['Seattle', 'USA'],
      ['Santa Clara', 'USA', 'California'],
      ['San Francisco', 'USA'],
      ['Mexico City', 'Mexico'],
      ['Warsaw', 'Poland'],
      ['Moscow', 'Russia'],
      ['Shanghai', 'China'],
      ['Jakarta', 'Indonesia'],
      ['Paris', 'France'],
      ['London', 'England'],
      ['Honolulu', 'USA'],
      ['New York City', 'USA'],
      ['Miami', 'USA'],
      ['Berlin', 'Germany'],
      ['Tokyo', 'Japan'],
      ['San Paulo', 'Brazil'],
      ['Sydney', 'Austrailia'],
      ['Johannesburg', 'South Africa'],
      ['Tripoli', 'Libya'],
      ['Bombay', 'India'],
      ['Santiago', 'Chile']
    ].sample

    city = city_data[0]
    country = city_data[1]
    state = city_data[2]

    cc_number = rand(100000000000000..999999999999999)
    cc_expiration = "#{rand(1..12)}/#{Date.today.year + rand(1..5)}"
    cc_ccv = rand(100..999)

    sale = Sale.new(units: units, first_name: first_name, last_name: last_name,
                    address: address, address2: address2, city: city, state: state,
                    zip: zip, country: country, credit_card_number: cc_number,
                    credit_card_date: cc_expiration, credit_card_ccv: cc_ccv)
    sale.save!
  end

  def update_sales_feed
    Pusher['sales_channel'].trigger('new_sale', {
      message: {
        units_sold: Sale.all.pluck(:units).sum,
        first_name: self.first_name,
        units: self.units,
        city: self.city,
        country: self.country,
        shipped: self.shipped
      }
    })
  end

  def self.ship_sales
    unshipped.update_all(shipped: true)
    update_map
  end

  def self.update_map
    marker_data = Gmaps4rails.build_markers(Sale.all) do |sale, marker|
      marker.lat sale.latitude
      marker.lng sale.longitude
    end

    Pusher['sales_channel'].trigger('update_map', {
      message: {
        marker_data: marker_data
      }
    })
  end

  def self.update_shipping_stats
    Pusher['sales_channel'].trigger('new_shipment', {
      message: {
        units_shipped: Sale.shipped.pluck(:units).sum
      }
    })
  end

  def self.simulate_sales(sleep_period: 0)
    rand(3..10).times do
      create_sale
    end
    sleep sleep_period #Add delay to prevent map from reloading too often
    ship_sales
    update_shipping_stats
  end

end
