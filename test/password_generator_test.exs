defmodule PasswordGeneratorTest do
  use ExUnit.Case

  setup do
    options = %{
      length: "10",
      numbers: "false",
      symbols: "false",
      uppercase: "false"
    }

    options_type = %{
      lowercase: Enum.map(?a..?z, & <<&1>>),
      numbers: Enum.map(0..9, & Integer.to_string(&1)),
      uppercase: Enum.map(?A..?Z, & <<&1>>),
      symbols: String.split("!#$%&()+,-./:;<=>?@[]^_{|}~", "", trim: true)
    }

    {:ok, result} = PasswordGenerator.generate(options)

    %{
      options_type: options_type,
      result: result
    }
  end

  test "returns a string", %{result: result} do
    assert is_bitstring(result)
  end

  test "returns error when no length is given" do
    options = %{invalid: "false"}

    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  test "returns error when length is not an integer" do
    options = %{length: "ab"}

    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  test "length of returned string is the option provided" do
    length_option = %{length: "5"}
    {:ok, result} = PasswordGenerator.generate(length_option)

    assert 5 = String.length(result)
  end

  test "returns a lowercase string just with the length", %{options_type: options_type} do
    length = %{length: "5"}
    {:ok, result} = PasswordGenerator.generate(length)

    assert String.contains?(result, options_type.lowercase)

    refute String.contains?(result, options_type.numbers)
    refute String.contains?(result, options_type.uppercase)
    refute String.contains?(result, options_type.symbols)
  end

  test "returns error when options values are not booleans" do
    options = %{
      length: "10",
      numbers: "invalid",
      symbols: "0",
      uppercase: "false"
    }

    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  test "returns error when options not allowed" do
    options = %{length: "5", invalid: "true"}

    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  test "returns error when 1 option not allowed" do
    options = %{length: "5", uppercase: "false", invalid: "true"}

    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  test "retunrs string uppercase", %{options_type: options_type} do
    options = %{
      length: "5",
      numbers: "false",
      symbols: "false",
      uppercase: "true"
    }

    assert {:ok, result} = PasswordGenerator.generate(options)
    assert String.contains?(result, options_type.uppercase)

    refute String.contains?(result, options_type.numbers)
    refute String.contains?(result, options_type.symbols)
  end

  test "returns string just with numbers", %{options_type: options_type} do
    options = %{
      length: "10",
      numbers: "true",
      symbols: "false",
      uppercase: "false"
    }

    assert {:ok, result} = PasswordGenerator.generate(options)
    assert String.contains?(result, options_type.numbers)

    refute String.contains?(result, options_type.uppercase)
    refute String.contains?(result, options_type.symbols)
  end

  test "returns string with uppercase and numbers", %{options_type: options_type} do
    options = %{
      length: "10",
      numbers: "true",
      symbols: "false",
      uppercase: "true"
    }

    assert {:ok, result} = PasswordGenerator.generate(options)
    assert String.contains?(result, options_type.numbers)
    assert String.contains?(result, options_type.uppercase)

    refute String.contains?(result, options_type.symbols)
  end

  test "returns string with symbols", %{options_type: options_type} do
    options = %{
      length: "10",
      numbers: "false",
      symbols: "true",
      uppercase: "false"
    }

    assert {:ok, result} = PasswordGenerator.generate(options)
    assert String.contains?(result, options_type.symbols)

    refute String.contains?(result, options_type.uppercase)
    refute String.contains?(result, options_type.numbers)
  end

  test "returns string with all included options", %{options_type: options_type} do
    options = %{
      length: "10",
      numbers: "true",
      symbols: "true",
      uppercase: "true"
    }

    assert {:ok, result} = PasswordGenerator.generate(options)
    assert String.contains?(result, options_type.symbols)
    assert String.contains?(result, options_type.uppercase)
    assert String.contains?(result, options_type.numbers)
  end

  test "returns string with symbols & uppercase", %{options_type: options_type} do
    options = %{
      length: "10",
      numbers: "false",
      symbols: "true",
      uppercase: "true"
    }

    assert {:ok, result} = PasswordGenerator.generate(options)
    assert String.contains?(result, options_type.symbols)
    assert String.contains?(result, options_type.uppercase)

    refute String.contains?(result, options_type.numbers)
  end

  test "returns string with symbols & numbers", %{options_type: options_type} do
    options = %{
      length: "10",
      numbers: "true",
      symbols: "true",
      uppercase: "false"
    }

    assert {:ok, result} = PasswordGenerator.generate(options)
    assert String.contains?(result, options_type.symbols)
    assert String.contains?(result, options_type.numbers)

    refute String.contains?(result, options_type.uppercase)
  end

end
