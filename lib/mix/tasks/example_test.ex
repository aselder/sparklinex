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

    # Test of the basic graphs
    basic_graphs = [:smooth, :bar]

    basic_graphs
    |> Enum.each(fn graph_type ->
      quick_graph("#{graph_type}", %{type: graph_type})

      #      quick_graph("labeled_#{graph_type}", %{type: graph_type, label: "Glucose", has_last: true})
    end)

    # More specific smooth graphs
    quick_graph("smooth_colored", %{type: :smooth, line_color: "purple"})

    quick_graph(
      "smooth_with_target",
      %{
        type: :smooth,
        target: 50,
        target_color: "#999999",
        line_color: "#6699cc",
        underneath_color: "#ebf3f6"
      }
    )

    quick_graph(
      "smooth_underneath_color",
      %{
        type: :smooth,
        line_color: "#6699cc",
        underneath_color: "#ebf3f6"
      }
    )

    # Test smooth sparkline with extreme value
    [100, 90, 95, 99, 80, 90]
    |> graph(%{
      type: :smooth,
      line_color: "#6699cc",
      underneath_color: "#ebf3f6"
    })
    |> graph_to_file("#{@output_dir}/smooth_similar_nonzero_values.png")

    quick_graph(
      "standard_deviation",
      %{
        type: :smooth,
        height: 100,
        line_color: "#666",
        has_std_dev: true,
        std_dev_color: "#cccccc"
      }
    )

    quick_graph(
      "standard_deviation_tall",
      %{
        type: :smooth,
        height: 300,
        line_color: "#666",
        has_std_dev: true,
        std_dev_color: "#cccccc"
      }
    )

    quick_graph(
      "standard_deviation_short",
      %{
        type: :smooth,
        height: 20,
        line_color: "#666",
        has_std_dev: true,
        std_dev_color: "#cccccc"
      }
    )

    quick_graph(
      "smooth_min_max",
      %{
        type: :smooth,
        has_min: true,
        has_max: true,
        has_last: true,
      }
    )

    # More in depth bar graphs

    quick_graph(
      "bar_tall",
      %{
        type: :bar,
        upper: 90,
        below_color: "blue",
        above_color: "red",
        bar_width: 7,
        height: 50
      }
    )

    quick_graph(
      "bar_wide",
      %{
        type: :bar,
        bar_width: 7
      }
    )

    [0, 1, 100, 2, 99, 3, 98, 4, 97, 5, 96, 6, 95, 7, 94, 8, 93, 9, 92, 10, 91]
    |> graph(%{
      type: :bar,
      upper: 90,
      below_color: "blue",
      above_color: "red",
      bar_width: 3
    })
    |> graph_to_file("#{@output_dir}/bar_extreme_values.png")

    # Create the HTML report
    write_html()
  end

  defp quick_graph(name, options) do
    @test_data
    |> graph(options)
    |> graph_to_file("#{@output_dir}/#{name}.png")
  end

  defp write_html do
    {:ok, file} = File.open("test/actual/index.html", [:write])
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
            <td class="last_column">#{
      image_tag("../../#{String.replace(file, "expected", "actual")}")
    }</td>
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
