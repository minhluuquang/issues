defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  import Issues.Cli, only: [parse_args: 1, sort_into_decensding_order: 1]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "three values returned if three given" do
    assert parse_args(["user", "project", "99"]) == {"user", "project", 99}
  end

  test "count is defaulted if two value is given" do
    assert parse_args(["user", "project"]) == {"user", "project", 4}
  end

  test "sort descending orders the correct way" do
    result = sort_into_decensding_order(fake_created_at_list(["c", "a", "b"]))

    issues =
      for issue <- result do
        Map.get(issue, "created_at")
      end

    assert issues == ~w{c b a}
  end

  defp fake_created_at_list(values) do
    for value <- values do
      %{"created_at" => value, "other_data" => "XXX"}
    end
  end
end
