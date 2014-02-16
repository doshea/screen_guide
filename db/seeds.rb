User.delete_all

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
User.create(
  first_name: 'Dylan',
  last_name: 'O\'Shea',
  email: 'doshea@gmail.com',
  username: 'doshea',
  is_admin: true,
  password: 'qwerty',
  password_confirmation: 'qwerty'
)