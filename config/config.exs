use Mix.Config

# Extract version from Mix
version = Mix.Project.config()[:version]

# Configure application
config :uncanny,
  ecto_repos: [Uncanny.Repo],
  version: version

# Configure Phoenix
config :phoenix, :json_library, Jason

# Configure Phoenix endpoint
config :uncanny, UncannyWeb.Endpoint,
  pubsub: [name: Uncanny.PubSub, adapter: Phoenix.PubSub.PG2],
  render_errors: [view: UncannyWeb.Errors.View, accepts: ~w(html json)]

# Configure Gettext
config :uncanny, Uncanny.Gettext, default_locale: "en"

# Configure Sentry
config :sentry,
  included_environments: [:prod],
  root_source_code_path: File.cwd!(),
  release: version

# Import runtime configuration
import_config "../rel/config/runtime.exs"

# Import environment configuration
import_config "#{Mix.env()}.exs"
