# PasswordGenerator


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `password_generator` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:password_generator, "~> 0.1.0"}
  ]
end
```
## Launch

```elixir
PasswordGenerator.generate(options)
```

Options:
```elixir
options = %{
  length: "5",
  numbers: "false",
  symbols: "false",
  uppercase: "false"
}
````
