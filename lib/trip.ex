defmodule Reader do

  def get_processed_info(file_processed) do
    file_processed |> Enum.reduce("", fn ( {k, v}, acc) ->
      acc = acc <> "\nTRIP to #{k}\n"
      movements = v
      |> Enum.reverse
      |> Enum.reduce("", fn ( segment, segment_acc) ->
        if segment["transport"] === "Hotel" do
          segment_acc = segment_acc <>
           "Hotel at #{segment["origin"]} on #{segment["dateOrigin"]} to #{segment["dateDestiny"]}\n"
        else
          segment_acc = segment_acc
          <> "#{segment["transport"]} from #{segment["origin"]} to #{segment["destiny"]} at #{segment["dateDestiny"]} #{segment["hourOrigin"]} to #{segment["hourDestiny"]}\n"
        end
      end)
      acc = acc
       <> movements
    end)

  end

  def get_base_on(file_content) do
  match = Regex.named_captures(~r/.*BASED:\s*(?<based>[A-Z]{3})/, file_content)

  match["based"]
  end

  def convert_date(booking) do

    if booking["transport"] === "Hotel" do
      DateTime.from_iso8601("#{booking["dateDestiny"]}T00:00:00Z")
    else
      DateTime.from_iso8601("#{booking["dateOrigin"]}T#{booking["hourDestiny"]}:00Z")
    end

  end

  def sort_by_dates(bookingA, bookingB) do
    {:ok, first_date, 0} = convert_date(bookingA)
    {:ok, second_date, 0} = convert_date(bookingB)

    result = Timex.compare(first_date,second_date, :minutes)

    if result === 1, do: false, else: true
  end

  def add_trip(bookings, based_on) do

    elem(Enum.reduce(bookings, {0, []}, fn(booking, bookings_acc) ->

      trip_index = elem(bookings_acc, 0)
      booking_trip = %{
        "dateDestiny" => booking["dateDestiny"],
        "dateOrigin" => booking["dateOrigin"],
        "destiny" => booking["destiny"],
        "hourDestiny" => booking["hourDestiny"],
        "hourOrigin" => booking["hourOrigin"],
        "origin" => booking["origin"],
        "transport" => booking["transport"],
        "trip" => trip_index
      }

      if(booking["destiny"] === based_on) do
        bookings_acc = {trip_index + 1, [booking_trip | elem(bookings_acc, 1)]}
      else
        bookings_acc = {trip_index, [booking_trip | elem(bookings_acc, 1)]}
      end
    end), 1)

  end

  def format_item(line) do
    Regex.named_captures(~r/\s(?<transport>[A-Za-z]+)\s(?<origin>[A-Za-z]+)\s(?<dateOrigin>\d{4}-\d{2}-\d{2})\s?(?<hourOrigin>(\d{2}:\d{2})?)\s->\s?(?<dateDestiny>(\d{4}-\d{2}-\d{2})?)\s?(?<destiny>([A-Za-z]+)?)\s?(?<hourDestiny>(\d{2}:\d{2})?).*/, line)
  end

  def read_file() do
    file = "input.txt"

    if File.exists?(file) do
      {:ok, content} = File.read(file)

      based_on = get_base_on(content)

      format_content = content
        |> String.replace("\r\n", "")
        |> String.replace("RESERVATION", "")
        |> String.split("SEGMENT:", trim: true)
        |> tl()
        |> Enum.map(fn line -> format_item(line) end)
        |> Enum.sort(fn bookingA, bookingB -> sort_by_dates(bookingA, bookingB) end)


        contentWithTrip = add_trip(format_content, based_on)
          |> Enum.group_by(fn x -> x["trip"] end)

        IO.puts get_processed_info contentWithTrip
        {:ok }
    else
      IO.puts "File not found"
    end
  end
end
