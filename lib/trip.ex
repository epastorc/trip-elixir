defmodule Reader do

  def get_processed_info(file_processed) do
    IO.inspect file_processed

    IO.puts file_processed |> Enum.reduce("", fn ( {k, v}, acc) ->
      acc = acc <>
       "TRIP to #{k}"
      movements = v |> Enum.reduce("", fn ( segment, segmentAcc) ->
        if segment["transport"] === "Hotel" do
          segmentAcc = segmentAcc <>
           "Hotel at #{segment["origin"]} on #{segment["dateOrigin"]} to #{segment["dateDestiny"]}"
        else
          segmentAcc = segmentAcc
          <> "#{segment["transport"]} from #{segment["origin"]} to #{segment["destiny"]} at #{segment["dateDestiny"]} #{segment["hourOrigin"]} to #{segment["hourDestiny"]}"
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

  def format_item(line) do
    Regex.named_captures(~r/\s(?<transport>[A-Za-z]+)\s(?<origin>[A-Za-z]+)\s(?<dateDestiny>\d{4}-\d{2}-\d{2})\s?(?<hourOrigin>(\d{2}:\d{2})?)\s->\s?(?<dateOrigin>(\d{4}-\d{2}-\d{2})?)\s?(?<destiny>([A-Za-z]+)?)\s?(?<hourDestiny>(\d{2}:\d{2})?).*/, line)
  end

  def read_file() do
    file = "input.txt"

    if File.exists?(file) do
      {:ok, content} = File.read(file)

      based_on = get_base_on(content)

      formatContent = content
        |> String.replace("\r\n", "")
        |> String.replace("RESERVATION", "")
        |> String.split("SEGMENT:", trim: true)
        |> tl()
        |> Enum.map(fn line -> format_item(line) end)
        |> Enum.group_by(fn x ->
          cond do
            x["destiny"] === based_on -> x["origin"]
            String.trim(x["destiny"]) === "" -> x["origin"]
            true -> x["destiny"]
          end
        end)

        IO.puts get_processed_info formatContent
    else
      IO.puts "File not found"
    end
  end
end
