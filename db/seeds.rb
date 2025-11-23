puts "Cleaning database..."

# Order matters because of foreign keys
TradeItem.destroy_all if defined?(TradeItem)
Trade.destroy_all     if defined?(Trade)
Review.destroy_all    if defined?(Review)
OrderItem.destroy_all if defined?(OrderItem)
Order.destroy_all     if defined?(Order)
CartItem.destroy_all  if defined?(CartItem)
Cart.destroy_all      if defined?(Cart)
WishlistItem.destroy_all if defined?(WishlistItem)
SupportTicket.destroy_all if defined?(SupportTicket)
Unitard.destroy_all   if defined?(Unitard)
User.destroy_all      if defined?(User)

puts "Creating users..."

vendor = User.create!(
  name: "Eternia Vendor",
  email: "vendor@example.com",
  password: "password",
  role: "vendor"
)

customer1 = User.create!(name: "Adam",  email: "adam@example.com",  password: "password")
customer2 = User.create!(name: "Teela", email: "teela@example.com", password: "password")
customer3 = User.create!(name: "Orko",  email: "orko@example.com",  password: "password")

puts "Creating carts for customers..."

cart1 = Cart.create!(user: customer1)
cart2 = Cart.create!(user: customer2)
cart3 = Cart.create!(user: customer3)

puts "Creating unitards..."

graphics = ["He-Man", "Skeletor", "Battle Cat", "She-Ra", "Castle Grayskull", "Man-At-Arms"]
colors   = ["Red", "Blue", "Green", "Purple", "Black", "Gold"]
sizes    = ["S", "M", "L", "XL", "XXL"]

12.times do |i|
  Unitard.create!(
    name: "#{graphics.sample} Power Suit #{i + 1}",
    description: "A premium Masters of the Universe themed unitard, crafted for ultimate performance.",
    price: rand(39.0..89.0).round(2),
    cut: ["Mens", "Womens", "Child"].sample,
    size: sizes.sample,
    sleeves: ["Sleeveless", "Short Sleeved", "Long Sleeved"].sample,
    graphic: graphics.sample,
    color: colors.sample,
    special_features: "Limited edition Eternia-approved collectible.",
    stock: rand(3..15),
    vendor: vendor
  )
end

unitards = Unitard.all.to_a

puts "Creating wishlist items..."

if defined?(WishlistItem)
  WishlistItem.create!(user: customer1, unitard: unitards.sample)
  WishlistItem.create!(user: customer2, unitard: unitards.sample)
  WishlistItem.create!(user: customer3, unitard: unitards.sample)
end

puts "Creating cart items..."

CartItem.create!(cart: cart1, unitard: unitards.sample, quantity: 1)
CartItem.create!(cart: cart1, unitard: unitards.sample, quantity: 2)
CartItem.create!(cart: cart2, unitard: unitards.sample, quantity: 1)

puts "Creating orders..."

order1 = Order.create!(
  user: customer1,
  total: 0,          # we'll update after items
  status: "completed",
  gift: false
)

order2 = Order.create!(
  user: customer2,
  total: 0,          # we'll update after items
  status: "completed",
  gift: true,
  recipient_name: "Princess Adora",
  recipient_email: "adora@example.com",
  gift_message: "For the honor of Grayskull!"
)

puts "Adding order items..."

o1_u1 = unitards[0]
o1_u2 = unitards[1]
o2_u1 = unitards[2]

OrderItem.create!(order: order1, unitard: o1_u1, quantity: 1, price: o1_u1.price)
OrderItem.create!(order: order1, unitard: o1_u2, quantity: 2, price: o1_u2.price)
OrderItem.create!(order: order2, unitard: o2_u1, quantity: 1, price: o2_u1.price)

# Recalculate totals based on items
[order1, order2].each do |order|
  total = order.order_items.sum { |oi| oi.price * oi.quantity }
  order.update!(total: total)
end

puts "Creating reviews..."

if defined?(Review)
  Review.create!(
    user: customer1,
    unitard: unitards.first,
    rating: 5,
    comment: "Absolutely amazing! I feel like He-Man!"
  )

  Review.create!(
    user: customer2,
    unitard: unitards.last,
    rating: 4,
    comment: "Great quality, but sleeves were a bit snug."
  )
end

puts "Creating a trade..."

if defined?(Trade) && defined?(TradeItem)
  trade = Trade.create!(
    proposer: customer1,
    recipient: customer2,
    status: "pending"
  )

  TradeItem.create!(trade: trade, unitard: unitards[3], side: "proposer")
  TradeItem.create!(trade: trade, unitard: unitards[4], side: "recipient")
end

puts "Creating support tickets..."

if defined?(SupportTicket)
  SupportTicket.create!(
    user: customer3,
    subject: "Missing package",
    message: "My unitard did not arrive. I suspect Skeletor again.",
    status: "open"
  )

  SupportTicket.create!(
    user: customer1,
    subject: "Trade issue",
    message: "The trade is stuck in pending. Please help!",
    status: "open"
  )
end

puts "🌟 DONE! Seed data loaded successfully."
