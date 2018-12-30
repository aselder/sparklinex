defmodule Sparklinex.Whisker do
  alias Sparklinex.MogrifyDraw
  alias Sparklinex.Whisker.Options

  def draw(
        data,
        spec = %Options{height: height, background_color: bk_color, step: step}
      ) do
    width = length(data) * step - 1
    canvas = MogrifyDraw.create_canvas(width, height, bk_color)

    canvas
    |> draw_whiskers(data, spec)
  end

  defp draw_whiskers(canvas, data, spec = %Options{step: step}) do
    data
    |> Enum.with_index()
    |> Enum.reduce(
      canvas,
      fn {value, index}, acc -> draw_whisker(acc, step * index, value, spec) end
    )
  end

  defp draw_whisker(canvas, x, 2, %Options{height: height, exception_color: color}) do
    canvas
    |> MogrifyDraw.draw_line({{x, mid_y(height)}, {x, 0}}, color)
  end

  defp draw_whisker(canvas, x, 1, %Options{height: height, whisker_color: color}) do
    canvas
    |> MogrifyDraw.draw_line({{x, mid_y(height)}, {x, 0}}, color)
  end

  defp draw_whisker(canvas, x, 0, %Options{height: height, whisker_color: color}) do
    y = Float.floor(height / 2)

    canvas
    |> MogrifyDraw.draw_line({{x, y}, {x, y}}, color)
  end

  defp draw_whisker(canvas, x, -1, %Options{height: height, whisker_color: color}) do
    canvas
    |> MogrifyDraw.draw_line({{x, mid_y(height)}, {x, height}}, color)
  end

  defp draw_whisker(canvas, x, -2, %Options{height: height, exception_color: color}) do
    canvas
    |> MogrifyDraw.draw_line({{x, mid_y(height)}, {x, height}}, color)
  end

  defp mid_y(height) do
    Float.ceil(height / 2 - 1)
  end
end
