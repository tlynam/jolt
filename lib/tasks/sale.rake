namespace :sale do

  desc "Ship sale units"
  task ship_sales: :environment do
    Sale.ship_sales
  end

end
