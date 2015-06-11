namespace :sale do

  desc 'Simulate Sales and Shipments'
  task simulate_sales: :environment do
    5.times do
      Sale.simulate_sales sleep_period: rand(1..7)
    end
  end

end
