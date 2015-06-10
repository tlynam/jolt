class SimulateSalesJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    10.times do
      rand(1..5).times do
        Sale.create_sale
      end

      sleep rand(1..5)

      Sale.ship_sales
      Sale.update_shipping_stats

      sleep rand(1..3)
    end
  end
end
