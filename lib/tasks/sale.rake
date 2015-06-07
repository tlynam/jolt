namespace :sale do

  desc 'Ship sale units'
  task ship_sales: :environment do
    Sale.ship_sales
  end

  desc 'Create Sale'
  task create_sale: :environment do
    Sale.create_sale
  end

end
