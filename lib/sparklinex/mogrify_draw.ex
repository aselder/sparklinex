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

  def draw_lines(canvas, coord_pairs) do
    Enum.reduce(coord_pairs, canvas, fn {p1, p2}, canvas -> draw_line(canvas, {p1, p2}) end)
  end

  def polygon(canvas, coords, color) do
    coords_string = coords
    |> Enum.map(fn {x, y} -> to_string(:io_lib.format("~f, ~f", [x / 1, y / 1])) end)
    |> Enum.join(" ")

    canvas
    |> custom("fill", color)
    |> custom("polygon", coords_string)
  end

  def set_line_color(canvas, color) do
    canvas
    |> custom("stroke", color)
  end

end
