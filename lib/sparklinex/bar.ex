defmodule Sparklinex.Bar do
  alias Sparklinex.Bar.Options
  alias Sparklinex.ChartData
  alias Sparklinex.MogrifyDraw

  def draw(data, spec = %Options{height: height, background_color: background_color}) do
    spec_with_width = %{spec | width: width(data, spec)}
    normalized_data = ChartData.normalize_data(data, :bar)
    canvas = MogrifyDraw.create_canvas(spec_with_width.width, height, background_color)

    canvas
    |> draw_rectangles(normalized_data, spec_with_width)
    |> draw_target_line(data, spec_with_width)
  end

  defp width(data, %Options{step: step, bar_width: bar_width}) do
    (length(data) * (step + bar_width) + 2) / 1
  end

  defp draw_rectangles(canvas, data, spec = %Options{}) do
    max = Enum.max(data)

    data
    |> Enum.with_index()
    |> Enum.reduce(
      canvas,
      fn {value, index}, acc -> draw_rectangle(acc, index, value, max, spec) end
    )
  end

  defp draw_rectangle(
         canvas,
         index,
         value,
         max_value,
         spec = %Options{height: height, step: step, bar_width: 1}
       ) do
    height_from_top = height - value / max_value * height
    left_edge = index * (1 + step) + 1

    canvas
    |> MogrifyDraw.draw_line({{left_edge, height}, {left_edge, height_from_top}}, rectangle_color(value, spec))
  end

  defp draw_rectangle(
         canvas,
         index,
         value,
         max_value,
         spec = %Options{height: height, step: step, bar_width: bar_width}
       ) do
    height_from_top = height - value / max_value * height
    left_edge = index * (bar_width + step) + 1

    canvas
    |> MogrifyDraw.set_line_color("transparent")
    |> MogrifyDraw.rectangle(
      {left_edge, height},
      {left_edge + bar_width - 1, height_from_top},
      rectangle_color(value, spec)
    )
  end

  defp rectangle_color(value, %Options{upper: boundary, above_color: above_color})
       when value >= boundary do
    above_color
  end

  defp rectangle_color(value, %Options{upper: boundary, below_color: below_color})
       when value < boundary do
    below_color
  end

  defp draw_target_line(canvas, _data, %Options{target: nil}) do
    canvas
  end

  defp draw_target_line(canvas, data, %Options{
         height: height,
         width: width,
         target: target,
         target_color: color
       }) do
    norm_value = ChartData.normalize_value(target, Enum.min(data), Enum.max(data))
    adjusted_target_value = height - 3 - norm_value / (101.0 / (height - 4))

    canvas
    |> MogrifyDraw.draw_line({{-5, adjusted_target_value}, {width + 5, adjusted_target_value}}, color)
  end
end
