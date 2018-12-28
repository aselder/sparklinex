defmodule Sparklinex.Bullet do
  alias Sparklinex.Bullet.Options
  alias Sparklinex.MogrifyDraw

  def draw(
        data,
        spec = %Options{height: height, width: width, good_color: good_color}
      ) do
    canvas = MogrifyDraw.create_canvas(width, height, good_color)

    canvas
    |> draw_sat_background(data, spec)
    |> draw_bad_background(data, spec)
    |> draw_target(data, spec)
    |> draw_bullet(data, spec)
  end

  defp draw_bad_background(canvas, %{good: good, bad: bad}, %Options{
         bad_color: bad_color,
         width: width,
         height: height
       }) do
    box_width = width * (bad / good)
    MogrifyDraw.rectangle(canvas, {0, 0}, {box_width, height}, bad_color)
  end

  defp draw_bad_background(canvas, _, _) do
    canvas
  end

  defp draw_sat_background(canvas, %{good: good, satisfactory: sat}, %Options{
         satisfactory_color: sat_color,
         width: width,
         height: height
       }) do
    box_width = width * (sat / good)
    MogrifyDraw.rectangle(canvas, {0, 0}, {box_width, height}, sat_color)
  end

  defp draw_sat_background(canvas, _, _) do
    canvas
  end

  defp draw_target(canvas, _, %Options{target: nil}) do
    canvas
  end

  defp draw_target(canvas, %{good: good}, %Options{
         height: height,
         target: target,
         width: width,
         bullet_color: bullet_color
       }) do
    target_x = width * (target / good)
    thickness = height / 3

    MogrifyDraw.rectangle(
      canvas,
      {target_x, thickness / 2},
      {target_x + 1, thickness * 2.5},
      bullet_color
    )
  end

  defp draw_bullet(canvas, %{value: value, good: good}, %Options{
         height: height,
         width: width,
         bullet_color: bullet_color
       }) do
    target_x = width * (value / good)
    thickness = height / 3
    MogrifyDraw.rectangle(canvas, {0, thickness}, {target_x, thickness * 2}, bullet_color)
  end
end
