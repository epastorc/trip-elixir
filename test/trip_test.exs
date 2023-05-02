defmodule TripTest do
  use ExUnit.Case
  doctest Reader

  test "get base on" do
    assert Reader.get_base_on("BASED: SVQ") == "SVQ"
  end

  test "convert_date from booking Hotel" do

    booking_trip = %{
      "dateDestiny" => "2023-03-02",
      "transport" => "Hotel"
    }
    assert Reader.convert_date(booking_trip) === {:ok, ~U[2023-03-02 00:00:00Z], 0}
  end

  test "convert_date from booking Train" do
    booking_trip = %{
      "dateOrigin" =>"2023-03-02",
      "hourDestiny" => "06:40",
      "transport" => "Train"
    }
    assert Reader.convert_date(booking_trip) === {:ok, ~U[2023-03-02 06:40:00Z], 0}
  end

  test "sort_by_dates" do
    booking_tripA = %{
      "dateOrigin" =>"2023-03-02",
      "hourDestiny" => "06:40",
      "transport" => "Train"
    }
    booking_tripB = %{
      "dateOrigin" =>"2023-04-02",
      "hourDestiny" => "06:40",
      "transport" => "Train"
    }
    assert Reader.sort_by_dates(booking_tripA, booking_tripB) === true
  end

  test "add_trip" do

    bookings = [
      %{
        "destiny" => "SVQ",
        "origin" => "BCN"
      },
      %{
        "destiny" => "SVQ",
        "origin" => "MCD"
      },
    ]


    expected_bookings =  [
      %{
        "dateDestiny" => nil,
        "dateOrigin" => nil,
        "destiny" => "SVQ",
        "hourDestiny" => nil,
        "hourOrigin" => nil,
        "origin" => "MCD",
        "transport" => nil,
        "trip" => 1
      },
      %{
        "dateDestiny" => nil,
        "dateOrigin" => nil,
        "destiny" => "SVQ",
        "hourDestiny" => nil,
        "hourOrigin" => nil,
        "origin" => "BCN",
        "transport" => nil,
        "trip" => 0
      }
    ]
    result = Reader.add_trip(bookings, "SVQ")

    assert result === expected_bookings
  end

  test "format_item Hotel" do

    line = " Hotel BCN 2023-01-05 -> 2023-01-10"

    expected_record = %{
      "dateDestiny" => "2023-01-10",
      "dateOrigin" => "2023-01-05",
      "destiny" => "",
      "hourDestiny" => "",
      "hourOrigin" => "",
      "origin" => "BCN",
      "transport" => "Hotel"
    }

    assert Reader.format_item(line) === expected_record
  end

  test "format_item Train" do

    line = " Train SVQ 2023-02-15 09:30 -> MAD 11:00"

    expected_record = %{
      "dateDestiny" => "",
      "dateOrigin" => "2023-02-15",
      "destiny" => "MAD",
      "hourDestiny" => "11:00",
      "hourOrigin" => "09:30",
      "origin" => "SVQ",
      "transport" => "Train"
    }

    assert Reader.format_item(line) === expected_record
  end

  test "main use case" do

    assert Reader.read_file() === {:ok}
  end
end
