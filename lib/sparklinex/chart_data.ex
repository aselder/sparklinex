defmodule Sparklinex.ChartData do

  def normalize_data(data, type) do
    min = min_value(data, type)
    max = max_value(data, type)
    normalize_data(data, min, max, type)
  end

  defp min_value(_data, :bar), do: 0.0
  defp min_value(data, _type), do: Enum.min(data)
  defp max_value(data, _type), do: Enum.max(data)
  defp normalize_data(data, _min, _max, :pie), do: data
  defp normalize_data(data, _min, _max, :bullet), do: data

  defp normalize_data(data, min, max, _type) do
    Enum.map(data, &(normalize_value(&1, min, max)))
  end

  defp normalize_value(_, min, min), do: min
  defp normalize_value(value, min, max) do
    (value - min) / (max - min) * 100
  end

end
