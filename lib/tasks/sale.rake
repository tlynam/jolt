namespace :sale do

  desc 'Ship sale units'
  task ship_sales: :environment do
    Sale.ship_sales
    Sale.update_shipping_stats
  end

  desc 'Create Sale'
  task create_sale: :environment do
    Sale.create_sale
  end

  desc 'Simulate Sales and Shipments'
  task simulate_sales: :environment do
    loop do
      rand(1..5).times do
        Rake::Task['sale:create_sale'].execute
      end
      sleep rand(1..5)
      Rake::Task['sale:ship_sales'].execute
      sleep rand(1..3)
    end
  end

end
