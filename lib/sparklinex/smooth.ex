defmodule Sparklinex.Smooth do

  alias Sparklinex.Smooth.Options
  alias Sparklinex.MogrifyDraw
  alias Sparklinex.ChartData

  def draw(data, chart_spec = %Options{}) do
    width = width(data, chart_spec)
    coords = data
             |> ChartData.normalize_data(:smooth)
             |> create_coords(chart_spec.height, chart_spec.step)

    canvas = MogrifyDraw.create_canvas(width, chart_spec.height, chart_spec.background_color)

    canvas = canvas
    |> MogrifyDraw.set_line_color(chart_spec.line_color)

    if chart_spec.underneath_color do
      MogrifyDraw.polygon(canvas, poly_coords(coords, chart_spec.height, width), chart_spec.underneath_color)
    else
      MogrifyDraw.draw_lines(canvas, each_pair(coords))
    end
  end

  defp width(data, %Options{step: step}) do
    (length(data) - 1) * step / 1
  end

  defp each_pair([p1 | [p2 | rest]]) do
    [{p1, p2} | each_pair([p2 | rest])]
  end
  defp each_pair([_p1 | _rest]), do: []

  defp create_coords(data, height, step) do
    data
    |> Enum.with_index()
    |> Enum.map(fn {y, x} -> {x * step, (height - 3 - y / (101.0 / (height - 4)))} end)
  end

  defp poly_coords(coords, height, width) do
    {first_x, first_y} = List.first(coords)
    {last_x, last_y} = List.last(coords)
    [{-1, height + 1}, {first_x - 1, first_y}, coords, {last_x + 1, last_y}, {width + 1, height + 1}]
    |> List.flatten()
  end
end

