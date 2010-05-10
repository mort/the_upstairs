# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_tilemaker_session',
  :secret      => 'ac48b22ae645bbd090f0c39b78774d4a3a5c1ead4f45559a9a44d66d9c84bfdfaba96b4f075bc5b18493db250db1e35f5094d3494e44cf9f2e51cbf116cb09fb'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
