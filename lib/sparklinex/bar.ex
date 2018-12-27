defmodule Sparklinex.Bar do
  alias Sparklinex.Bar.Options
  alias Sparklinex.MogrifyDraw
  alias Sparklinex.ChartData

  def draw(data, chart_spec = %Options{}) do
    width = width(data, chart_spec)
    normalized_data = ChartData.normalize_data(data, :bar)
    canvas = MogrifyDraw.create_canvas(width, chart_spec.height, chart_spec.background_color)

    canvas
    |> draw_rectangles(
      normalized_data,
      chart_spec.bar_width,
      chart_spec.step,
      chart_spec.upper,
      chart_spec.height,
      chart_spec.above_color,
      chart_spec.below_color
    )
    |> draw_target_line(
      chart_spec.target,
      chart_spec.target_color,
      chart_spec.height,
      width,
      data
    )
  end

  defp width(data, %Options{step: step, bar_width: width}) do
    (length(data) * (step + width) + 2) / 1
  end

  defp draw_rectangles(canvas, data, bar_width, step, boundary, height, above_color, below_color) do
    max = Enum.max(data)

    data
    |> Enum.with_index()
    |> Enum.reduce(
      canvas,
      fn {value, index}, acc ->
        draw_rectangle(
          acc,
          index,
          value,
          max,
          boundary,
          bar_width,
          step,
          height,
          above_color,
          below_color
        )
      end
    )
  end

  defp draw_rectangle(
         canvas,
         index,
         value,
         max_value,
         boundary,
         1,
         step,
         height,
         above_color,
         below_color
       ) do
    color = rectangle_color(value, boundary, above_color, below_color)
    height_from_top = height - value / max_value * height
    left_edge = index * (1 + step) + 1

    canvas
    |> MogrifyDraw.set_line_color(color)
    |> MogrifyDraw.draw_line({{left_edge, height}, {left_edge, height_from_top}})
  end

  defp draw_rectangle(
         canvas,
         index,
         value,
         max_value,
         boundary,
         bar_width,
         step,
         height,
         above_color,
         below_color
       ) do
    color = rectangle_color(value, boundary, above_color, below_color)
    height_from_top = height - value / max_value * height
    left_edge = index * (bar_width + step) + 1

    canvas
    |> MogrifyDraw.set_line_color("transparent")
    |> MogrifyDraw.rectangle(
      {left_edge, height},
      {left_edge + bar_width - 1, height_from_top},
      color
    )
  end

  defp rectangle_color(value, boundary, above_color, _below_color) when value >= boundary do
    above_color
  end

  defp rectangle_color(value, boundary, _above_color, below_color) when value < boundary do
    below_color
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
end
