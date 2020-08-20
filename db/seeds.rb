user = User.create!(email: 'dev@test.com', password: 'password')

kobe = Player.create!(name: 'Kobe Bryant')

Listing.create!(
  title: 'Rookie Year Kobe!!!',
  description: 'For real',
  player: kobe,
  price: 1_000_000,
  user: user
)
Listing.create!(
  title: 'Some other Kobe',
  description: 'Not as cool',
  player: kobe,
  price: 1200,
  user: user
)
