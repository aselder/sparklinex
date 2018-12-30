defmodule Sparklinex.Smooth do
  alias Sparklinex.ChartData
  alias Sparklinex.MogrifyDraw
  alias Sparklinex.Smooth.Options

  def draw(
        data,
        spec = %Options{height: height, background_color: bk_color, line_color: line_color}
      ) do
    spec_with_width = %{spec | width: width(data, spec)}
    normalized_data = ChartData.normalize_data(data, :smooth)

    coords = create_coords(normalized_data, spec_with_width)
    canvas = MogrifyDraw.create_canvas(spec_with_width.width, height, bk_color)

    canvas
    |> draw_std_dev_box(normalized_data, spec_with_width)
    |> MogrifyDraw.set_line_color(line_color)
    |> plot_data(coords, spec_with_width)
    |> draw_target_line(data, spec_with_width)
    |> draw_max(coords, spec_with_width)
    |> draw_min(coords, spec_with_width)
    |> draw_last(coords, spec_with_width)
  end

  defp width(data, %Options{step: step}) do
    (length(data) - 1) * step / 1
  end

  defp each_pair([p1 | [p2 | rest]]) do
    [{p1, p2} | each_pair([p2 | rest])]
  end

  defp each_pair([_p1 | _rest]), do: []

  defp create_coords(data, %Options{step: step, height: height}) do
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

  defp plot_data(canvas, coords, %Options{underneath_color: nil}) do
    MogrifyDraw.draw_lines(canvas, each_pair(coords))
  end

  defp plot_data(canvas, coords, %Options{width: width, underneath_color: color, height: height}) do
    MogrifyDraw.polygon(canvas, poly_coords(coords, height, width), color)
  end

  defp draw_std_dev_box(canvas, data, %Options{
         height: height,
         has_std_dev: true,
         std_dev_color: color,
         width: width
       }) do
    std_dev = Statistics.stdev(data)
    mid = Enum.sum(data) / length(data)
    lower = height - 3 - (mid - std_dev) / (101.0 / (height - 4))
    upper = height - 3 - (mid + std_dev) / (101.0 / (height - 4))

    canvas
    |> MogrifyDraw.set_line_color("transparent")
    |> MogrifyDraw.rectangle({0, lower}, {width, upper}, color)
  end

  defp draw_std_dev_box(canvas, _data, %Options{has_std_dev: false}) do
    canvas
  end

  defp draw_target_line(canvas, _data, %Options{target: nil}) do
    canvas
  end

  defp draw_target_line(canvas, data, %Options{
         target: target,
         target_color: color,
         height: height,
         width: width
       }) do
    norm_value = ChartData.normalize_value(target, Enum.min(data), Enum.max(data))
    adjusted_target_value = height - 3 - norm_value / (101.0 / (height - 4))

    canvas
    |> MogrifyDraw.draw_line({{-5, adjusted_target_value}, {width + 5, adjusted_target_value}}, color)
  end

  defp draw_min(canvas, coords, %Options{has_min: true, min_color: color}) do
    min_point = Enum.min_by(coords, fn {_x, y} -> -y end)
    MogrifyDraw.draw_box(canvas, min_point, 2, color)
  end

  defp draw_min(canvas, _coords, %Options{has_min: false}) do
    canvas
  end

  defp draw_max(canvas, coords, %Options{has_max: true, max_color: color}) do
    max_point = Enum.max_by(coords, fn {_x, y} -> -y end)
    MogrifyDraw.draw_box(canvas, max_point, 2, color)
  end

  defp draw_max(canvas, _coords, %Options{has_max: false}) do
    canvas
  end

  defp draw_last(canvas, coords, %Options{has_last: true, last_color: color}) do
    last_point = List.last(coords)
    MogrifyDraw.draw_box(canvas, last_point, 2, color)
  end

  defp draw_last(canvas, _coords, %Options{has_last: false}) do
    canvas
  end
end
