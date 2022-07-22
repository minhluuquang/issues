defmodule Issues.TableFormatter do
  def print_table_for_columns(rows, headers) do
    with data_by_columns = split_into_columns(rows, headers),
         columns_widths = width_of(data_by_columns),
         format = format_for(columns_widths) do
      puts_one_line_in_columns(headers, format)
      IO.puts(separator(columns_widths))
      puts_in_columns(data_by_columns, format)
    end
  end

  def split_into_columns(rows, headers) do
    for header <- headers do
      for row <- rows do
        printable(row[header])
      end
    end
  end

  def printable(str) when is_binary(str) do
    str
  end

  def printable(str) do
    to_string(str)
  end

  def width_of(columns) do
    for col <- columns do
      col |> Enum.map(&String.length/1) |> Enum.max()
    end
  end

  def format_for(column_widths) do
    Enum.map_join(column_widths, " | ", fn width -> "~#{width}s" end) <> "~n"
  end

  def separator(column_widths) do
    Enum.map_join(column_widths, "-+-", fn width -> List.duplicate("-", width) end)
  end

  def puts_in_columns(data_by_columns, format) do
    data_by_columns
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.each(&puts_one_line_in_columns(&1, format))
  end

  def puts_one_line_in_columns(fields, format) do
    :io.format(format, fields)
  end
end
