defmodule PasswordGenerator do
  @moduledoc """
  Generates random password depending on parameters, Module main function is `generate(options)`
  That function takes the options map.
  Options examples:
  ```
  options = %{
    "length": "5",
    "numbers": "false",
    "symbols": "false",
    "uppercase": "false"
  }
  ```
  The options are only 4, `length`, `numbers`, `uppercase` and `symbols`.
  """

  @allowed_options [:length, :numbers, :uppercase, :symbols]

  @doc """
  Generates password for given options:

  ## Examples
    options = %{
      "length": "5",
      "numbers": "false",
      "symbols": "false",
      "uppercase": "false"
    }

    iex> PasswordGenerator.generate(options)
    "abcddf"

    options = %{
      "length": "5",
      "numbers": "true",
      "symbols": "false",
      "uppercase": "false"
    }

    iex> PasswordGenerator.generate(options)
    "abcdd3"
  """

  @spec generate(options :: map()) :: {:ok, bitstring()} | {:error, bitstring()}
  def generate(options) do
    result = Map.has_key?(options, :length)
    validate_length(result, options)
  end

  defp validate_length(false, _options), do: {:error, "Please provide a length"}
  defp validate_length(true, options) do
    numbers = Enum.map(0..9, & Integer.to_string(&1))
    length = options[:length]
    length = String.contains?(length, numbers)

    validate_length_is_integer(length, options)
  end

  defp validate_length_is_integer(false, _options), do: {:error, "Only integers allowed for length"}
  defp validate_length_is_integer(true, options) do
    length = options[:length]
      |> String.trim()
      |> String.to_integer()
    options_without_length = Map.delete(options, :length)
    options_values = Map.values(options_without_length)
    value =
      options_values
        |> Enum.all?(fn x -> String.to_atom(x) |> is_boolean() end)

    validate_options_values_are_booleans(value, length, options_without_length)
  end

  defp validate_options_values_are_booleans(false, _length, _options), do: {:error, "Only booleans allowed for options"}
  defp validate_options_values_are_booleans(true, length, options) do
    options = included_options(options)
    valid_options? = options |> Enum.all?(&(&1 in @allowed_options))

    validate_options(valid_options?, length, options)
  end

  defp included_options(options) do
    Enum.filter(options, fn {_key, value}->
      value
        |> String.trim()
        |> String.to_existing_atom()
    end)
      |> Enum.map(fn {key, _value} -> key end)
  end

  defp validate_options(false, _length, _options), do: {:error, "Invalid options"}
  defp validate_options(true, length, options) do
    generate_strings(length, options)
  end

  defp generate_strings(length, options) do
    options = [:lowercase_letter | options]
    included = include(options)
    length = length - length(included)
    randdom_strings = generate_random_strings(length, options)
    strings = included ++ randdom_strings
    get_result(strings)
  end

  defp include(options) do
    options
      |> Enum.map(&get(&1))
  end

  defp get_result(strings) do
    string =
      strings
      |> Enum.shuffle()
      |> to_string()

    {:ok, string}
  end

  defp get(:lowercase_letter) do
    <<Enum.random(?a..?z)>>
  end

  defp get(:uppercase) do
    <<Enum.random(?A..?Z)>>
  end

  defp get(:symbols) do
    String.split("!#$%&()+,-./:;<=>?@[]^_{|}~", "", trim: true)
  end

  defp get(:numbers) do
    Enum.random(0..9)
      |> Integer.to_string()
  end

  defp generate_random_strings(length, options) do
    Enum.map(1..length, fn _value ->
      Enum.random(options) |> get()
    end)
  end
end
