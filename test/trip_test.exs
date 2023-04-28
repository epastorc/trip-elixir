defmodule TripTest do
  use ExUnit.Case
  doctest Trip

  test "greets the world" do
    assert Trip.hello() == :world
  end
end
