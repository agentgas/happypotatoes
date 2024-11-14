# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# create Rate entries

# 1 entry every minute over one week
# 7 days times 24 hours times 60 minutes
total_entries = 7 * 24 * 60

# init Rand
r = Random.new

# create entry every second over a month with starting on 1 january 2024
start_date = DateTime.new(2024, 1, 1, 0, 0, 0)

total_entries.times do
  Rate.create(time: start_date, value: r.rand(0.0...200.0).round(2))
  start_date += 1.minute
end
