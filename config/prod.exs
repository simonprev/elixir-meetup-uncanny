use Mix.Config

# Configure Phoenix endpoint
config :uncanny, UncannyWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true

# Configure Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  level: :info,
  metadata: [:request_id]
