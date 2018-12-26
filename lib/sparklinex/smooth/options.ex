defmodule Sparklinex.Smooth.Options do
  defstruct step: 2,
            height: 14,
            background_color: "white",
            min_color: "blue",
            max_color: "green",
            last_color: "red",
            has_min: false,
            has_max: false,
            has_last: false,
            line_color: "lightgrey",
            has_std_dev: false,
            std_dev_color: "#efefef",
            target: nil,
            target_color: "white",
            underneath_color: nil
end
