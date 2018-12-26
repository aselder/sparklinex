defmodule Sparklinex.Smooth do
  alias Sparklinex.Smooth.Options
  alias Sparklinex.MogrifyDraw
  alias Sparklinex.ChartData

  def draw(data, chart_spec = %Options{}) do
    width = width(data, chart_spec)
    normalized_data = ChartData.normalize_data(data, :smooth)

    coords =
      normalized_data
      |> create_coords(chart_spec.height, chart_spec.step)

    canvas = MogrifyDraw.create_canvas(width, chart_spec.height, chart_spec.background_color)

    canvas
    |> draw_std_dev_box(
      chart_spec.has_std_dev,
      normalized_data,
      chart_spec.height,
      width,
      chart_spec.std_dev_color
    )
    |> MogrifyDraw.set_line_color(chart_spec.line_color)
    |> plot_data(coords, chart_spec.underneath_color, chart_spec.height, width)
    |> draw_target_line(
      chart_spec.target,
      chart_spec.target_color,
      chart_spec.height,
      width,
      data
    )
    |> draw_max(chart_spec.has_max, coords, chart_spec.max_color)
    |> draw_min(chart_spec.has_min, coords, chart_spec.min_color)
    |> draw_last(chart_spec.has_last, coords, chart_spec.last_color)
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
    |> Enum.map(fn {y, x} -> {x * step, height - 3 - y / (101.0 / (height - 4))} end)
  end

  defp poly_coords(coords, height, width) do
    {first_x, first_y} = List.first(coords)
    {last_x, last_y} = List.last(coords)

    [
      {-1, height + 1},
      {first_x - 1, first_y},
      coords,
      {last_x + 1, last_y},
      {width + 1, height + 1}
    ]
    |> List.flatten()
  end

  defp plot_data(canvas, coords, nil, _height, _width) do
    MogrifyDraw.draw_lines(canvas, each_pair(coords))
  end

  defp plot_data(canvas, coords, underneath_color, height, width) do
    MogrifyDraw.polygon(canvas, poly_coords(coords, height, width), underneath_color)
  end

  defp draw_std_dev_box(canvas, true, data, height, width, color) do
    std_dev = Statistics.stdev(data)
    mid = Enum.sum(data) / length(data)
    lower = height - 3 - (mid - std_dev) / (101.0 / (height - 4))
    upper = height - 3 - (mid + std_dev) / (101.0 / (height - 4))

    canvas
    |> MogrifyDraw.set_line_color("transparent")
    |> MogrifyDraw.rectangle({0, lower}, {width, upper}, color)
  end

  defp draw_std_dev_box(canvas, false, _data, _height, _width, _color) do
    canvas
  end

  defp draw_target_line(canvas, nil, _target_color, _height, _width, _data) do
    canvas
  end

  defp draw_target_line(canvas, target_value, target_color, height, width, data) do
    norm_value = ChartData.normalize_value(target_value, Enum.min(data), Enum.max(data))
    adjusted_target_value = height - 3 - norm_value / (101.0 / (height - 4))

    canvas
    |> MogrifyDraw.set_line_color(target_color)
    |> MogrifyDraw.draw_line({{-5, adjusted_target_value}, {width + 5, adjusted_target_value}})
  end

  defp draw_min(canvas, true, coords, color) do
    min_point = Enum.min_by(coords, fn {_x, y} -> y end)
    MogrifyDraw.draw_box(canvas, min_point, 2, color)
  end

  defp draw_min(canvas, false, _coords, _color) do
    canvas
  end

  defp draw_max(canvas, true, coords, color) do
    max_point = Enum.max_by(coords, fn {_x, y} -> y end)
    MogrifyDraw.draw_box(canvas, max_point, 2, color)
  end

  defp draw_max(canvas, false, _coords, _color) do
    canvas
  end

  defp draw_last(canvas, true, coords, color) do
    last_point = List.last(coords)
    MogrifyDraw.draw_box(canvas, last_point, 2, color)
  end

  defp draw_last(canvas, false, _coords, _color) do
    canvas
  end
end
