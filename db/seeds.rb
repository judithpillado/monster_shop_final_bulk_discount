# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Merchant.destroy_all
Item.destroy_all

# Merchants:
clothing_boutique = Merchant.create(name: "Elah's Boutique", address: '227 Skirt St.', city: 'Chicago', state: 'IL', zip: 60619)
shoe_store = Merchant.create(name: "Sinai's Shoe Store", address: '1211 Boot St.', city: 'Chicago', state: 'IL', zip: 60638)

# Clothing Boutique Items:
blouse = clothing_boutique.items.create(name: "Blouse", description: "Soft pink chiffon blouse", price: 15, image: "https://m.media-amazon.com/images/I/71HraJAaF3L._SR500,500_.jpg", inventory: 15)
skirt = clothing_boutique.items.create(name: "Maxi Skirt", description: "Multi-colored a-line maxi skirt", price: 30, image: "https://cache.net-a-porter.com/images/products/1104844/1104844_ou_2000_q80.jpg", inventory: 30)
pijamas = clothing_boutique.items.create(name: "PJs", description: "Warm pjs for the winter", price: 20, image: "https://www.zaflynn.com/33088-large_default/women-s-pajamas-cotton-flannel-hoodie-winter-warm-sleepwear-set-c61805stkuh.jpg", inventory: 20)

# Shoe Store Items:
boots = shoe_store.items.create(name: "Winter Boots", description: "Bearpaw pink boots", price: 50, image: "https://www.rogansshoes.com/data/default/images/catalog/385/BP_1962Y_PNK1.JPG", inventory: 50)
sandals = shoe_store.items.create(name: "Sandals", description: "Leather strappy sandals", price: 15, image: "https://www.bodenimages.com/productimages/zoom/19gsum_c0384_gld.jpg", inventory: 15)
heels = shoe_store.items.create(name: "Heels", description: "Bowknot hight heels", price: 30, image: "https://cdn.shopify.com/s/files/1/0083/0849/0336/products/DP0423HS_grande_6b9794eb-ff1a-4626-bbde-6617b9b89187_grande.jpg?v=1590151377", inventory: 30)

# Users:
user = User.create(name: "Jane Doe", address: "123 Palm St", city: "Chicago", state: "IL", zip: 60623, email: "janedoe@email.com", password: "password", password_confirmation: "password")
merchant_employee1 = User.create(name: "Samaria Pillado", address: "456 Cool St", city: "Chicago", state: "IL", zip: 60619, email: "samaria@email.com", password: "password", password_confirmation: "password", role: 1)
merchant_employee2 = User.create(name: "Cloe Pillado", address: "456 Cool St", city: "Chicago", state: "IL", zip: 60619, email: "cloe@email.com", password: "password", password_confirmation: "password", role: 1)
admin = User.create(name: "Michael Scott", address: "126 Kellum Court", city: "Scranton", state: "PA", zip: 18510, email: "michaelscarn@email.com", password: "holly", password_confirmation: "holly", role: 2)

discount1 = clothing_boutique.discounts.create!(discount_percentage: 30, minimum_quantity: 5)
discount2 = shoe_store.discounts.create!(discount_percentage: 20, minimum_quantity: 10)
