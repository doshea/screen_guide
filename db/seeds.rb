User.delete_all
Show.delete_all
Season.delete_all
Episode.delete_all

#creates a non-admin User
User.create(
  first_name: 'Test',
  last_name: 'Testerson',
  email: 'test@gmail.com',
  username: 'test_user',
  is_admin: false,
  password: 'qwerty',
  password_confirmation: 'qwerty'
)

#creates an admin User
doshea = User.create(
  first_name: 'Dylan',
  last_name: 'O\'Shea',
  email: 'doshea@gmail.com',
  username: 'doshea',
  is_admin: true,
  password: 'qwerty',
  password_confirmation: 'qwerty'
)

party_down = Show.create(
  name: 'Party Down',
  image: 'http://ia.media-imdb.com/images/M/MV5BNzEyMDkyMDM1M15BMl5BanBnXkFtZTcwNzc5NTczMw@@._V1_SX640_SY720_.jpg',
  active: false
)

pd_s01 = Season.create(number: 1)
pd_s02 = Season.create(number: 2)

party_down.seasons << pd_s01
party_down.seasons << pd_s02

pd_s01.episodes << Episode.create(title: 'Willow Canyon Homeowners Annual Party', air_date: Date.new(2009, 3, 20), number: 1)
pd_s01.episodes << Episode.create(title: 'California College Conservative Union Caucus', air_date: Date.new(2009, 3, 27), number: 2)
pd_s01.episodes << Episode.create(title: 'Pepper McMasters Singles Seminar', air_date: Date.new(2009, 4, 3), number: 3)
pd_s01.episodes << Episode.create(title: 'Investors Dinner', air_date: Date.new(2009, 4, 10), number: 4)
pd_s01.episodes << Episode.create(title: 'Sin Say Shun Awards Afterparty', air_date: Date.new(2009, 4, 17), number: 5)
pd_s01.episodes << Episode.create(title: 'Taylor Stiltskin Sweet Sixteen', air_date: Date.new(2009, 4, 24), number: 6)
pd_s01.episodes << Episode.create(title: 'Brandix Corporate Retreat', air_date: Date.new(2009, 5, 1), number: 7)
pd_s01.episodes << Episode.create(title: 'Celebrate Ricky Sargulesh', air_date: Date.new(2009, 5, 8), number: 8)
pd_s01.episodes << Episode.create(title: 'James Rolf High School Twentieth Reunion', air_date: Date.new(2009, 5, 15), number: 9)
pd_s01.episodes << Episode.create(title: 'Stennheiser-Pong Wedding Reception', air_date: Date.new(2009, 5, 22), number: 10)

doshea.shows << party_down