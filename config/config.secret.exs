use Mix.Config
config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id: "5394300199296120",
  client_secret: "754246b9792708d38770baaf24dcbe0a0",
  redirect_uri: "http://localhost:4000/auth/facebook/callback"
