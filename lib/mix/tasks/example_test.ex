defmodule Mix.Tasks.ExampleTest do
  use Mix.Task

  import Sparklinex

  @output_dir "test/actual"
  @test_data [
    1,
    5,
    15,
    20,
    30,
    50,
    57,
    58,
    55,
    48,
    44,
    43,
    42,
    42,
    46,
    48,
    49,
    53,
    55,
    59,
    60,
    65,
    75,
    90,
    105,
    106,
    107,
    110,
    115,
    120,
    115,
    120,
    130,
    140,
    150,
    160,
    170,
    100,
    100,
    10
  ]

  def run(_) do
    File.mkdir_p(@output_dir)
    basic_graphs = [:smooth]

    basic_graphs
    |> Enum.each(
         fn graph_type ->
           quick_graph("#{graph_type}", %{type: graph_type})
           quick_graph("labeled_#{graph_type}", %{type: graph_type, label: "Glucose"})
         end
       )

    write_html()
  end

  def quick_graph(name, options) do
    @test_data
    |> graph(options)
    |> graph_to_file("#{@output_dir}/#{name}.png")
  end

  defp write_html do
    {:ok, file} = File.open "test/actual/index.html", [:write]
    IO.binwrite(file, html_header())
    IO.binwrite(file, table_header())
    Path.wildcard("test/expected/*")
    |> Enum.each(fn test_file -> IO.binwrite(file, table_row(test_file)) end)
    IO.binwrite(file, close())
    File.close(file)
  end

  defp table_row(file) do
    """
          <tr>
            <td class="first_column">#{image_tag("../../#{file}")}</td>
            <td class="last_column">#{image_tag("../../#{String.replace(file, "expected", "actual")}")}</td>
          </tr>
    """
  end

  defp image_tag(path) do
    ~s(<img src="#{path}" />)
  end

  defp html_header do
    """
    <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
    <head>
    <style>
    .first_column {
      text-align: right;
    }
    .last_column {
      text-align: left;
    }
    img {
      border: 1px solid #e0e0e0;
    }
    </style>
    </head>
    <body>
    """
  end

  defp table_header do
    """
    <table>
    <thead>
      <tr>
        <td class="first_column">Expected</td>
        <td class="last_column">Actual</td>
      </tr>
    </thead>
    <tbody>

    """
  end

  defp close do
    """
      </table>
      </body>
      </html>
    """
  end

end

