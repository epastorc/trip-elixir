defmodule Reader do

  def format_item(line) do
    IO.puts "The processed line is: #{line}"

    Regex.named_captures(~r/\s(?<transport>[A-Za-z]+)\s(?<origin>[A-Za-z]+)\s(?<dateDestiny>\d{4}-\d{2}-\d{2})\s?(?<hourOrigin>(\d{2}:\d{2})?)\s->\s?(?<dateOrigin>(\d{4}-\d{2}-\d{2})?)\s?(?<destiny>([A-Za-z]+)?)\s?(?<hourDestiny>(\d{2}:\d{2})?).*/, line)
  end
  def read_file() do
    file = "trip.txt"

    if File.exists?(file) do
      {:ok, content} = File.read(file)

      formatContent = content
        |> String.replace("\r\n", "")
        |> String.replace("RESERVATION", "")
        |> String.split("SEGMENT:", trim: true)
        |> tl()
        |> Enum.map(fn line -> format_item(line) end)


        IO.inspect "formatContent: #{formatContent}"

    else
      IO.puts "File not found"
    end
  end
end

Reader.read_file()
