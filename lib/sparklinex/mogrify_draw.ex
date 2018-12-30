defmodule Sparklinex.MogrifyDraw do
  import Mogrify

  def create_canvas(width, height, background_color) do
    %Mogrify.Image{path: "test.png", ext: "png"}
    |> custom("size", "#{width}x#{height}")
    |> canvas(background_color)
  end

  def draw_line(canvas, {{x1, y1}, {x2, y2}}) do
    custom(
      canvas,
      "draw",
      "line #{to_string(:io_lib.format("~f, ~f ~f, ~f", [x1 / 1, y1 / 1, x2 / 1, y2 / 1]))}"
    )
  end

  def draw_line(canvas, {{x1, y1}, {x2, y2}}, color) do
    canvas
    |> set_line_color(color)
    |> draw_line({{x1, y1}, {x2, y2}})
  end

  def draw_lines(canvas, coord_pairs) do
    Enum.reduce(coord_pairs, canvas, fn {p1, p2}, canvas -> draw_line(canvas, {p1, p2}) end)
  end

  def polygon(canvas, coords, color) do
    canvas
    |> custom("fill", color)
    |> polygon(coords)
  end

  def polygon(canvas, coords) do
    coords_string =
      coords
      |> Enum.map(fn {x, y} -> to_string(:io_lib.format("~f, ~f", [x / 1, y / 1])) end)
      |> Enum.join(" ")

    canvas
    |> custom("draw", "polygon #{coords_string}")
  end

  def draw_box(canvas, {x, y}, offset, color) do
    rectangle(canvas, {x - offset, y - offset}, {x + offset, y + offset}, color)
  end

  def draw_box(canvas, {x, y}, offset) do
    rectangle(canvas, {x - offset, y - offset}, {x + offset, y + offset})
  end

  def rectangle(canvas, {upper_left_x, upper_left_y}, {lower_right_x, lower_right_y}, color) do
    canvas
    |> custom("fill", color)
    |> rectangle({upper_left_x, upper_left_y}, {lower_right_x, lower_right_y})
  end

  def rectangle(canvas, {upper_left_x, upper_left_y}, {lower_right_x, lower_right_y}) do
    canvas
    |> custom(
      "draw",
      "rectangle #{
        to_string(
          :io_lib.format("~f,~f ~f,~f", [
            upper_left_x / 1,
            upper_left_y / 1,
            lower_right_x / 1,
            lower_right_y / 1
          ])
        )
      }"
    )
  end

  def set_line_color(canvas, color) do
    canvas
    |> custom("stroke", color)
  end
end
