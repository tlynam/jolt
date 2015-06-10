# System Prerequisites

1. Mysql
2. Ruby > 2

# Install Steps

1. git clone
2. bundle install
3. Create Mysql development database
4. Run migrations with rake db:migrate
5. Start server

# Sales Simulator

Sales are created either through the website form or through a rake task:
rake sale:create_sale

Sales aren't shipped automatically as this is a manual process.  There's a separate rake task for shipping all currently unshippped sales.  When shipping, the Google Map markers are updated with the sale destinations:
rake sale:ship_sales

Finally, there's a simulator that loops while creating a random number of sales, sleeps, then ships the sales:
rake sale:simulate_sales

You can reload the database to clear the database and start over:
rake db:schema:load

# Tests

You can run the MiniTest tests with: rake test
