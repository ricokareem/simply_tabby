# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_rails-2.3.3_session',
  :secret      => '48abc729ea53aa4df9812748bf0971eb02f6364324ba42e835fdd10d19ef591c893bbba65158ead2c2e5e2f90b1c2a84fe02095c5ab768781780164ec45ef367'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
