defmodule Sparklinex do
  @moduledoc """
  Documentation for Sparklinex.
  """

  @doc """
  """
  def graph(data_points, opts = %{type: type}) do
    graph_opts = Map.drop(opts, [:type])

    case type do
      :smooth -> smooth(data_points, graph_opts)
      :bar -> bar(data_points, graph_opts)
      :bullet -> bullet(data_points, graph_opts)
    end
  end

  @doc """
  """
  def smooth(data_points, opts \\ %{}) do
    Sparklinex.Smooth.draw(data_points, struct(%Sparklinex.Smooth.Options{}, opts))
  end

  @doc """
  """
  def bar(data_points, opts \\ %{}) do
    Sparklinex.Bar.draw(data_points, struct(%Sparklinex.Bar.Options{}, opts))
  end

  @doc """
  """
  def bullet(data = %{value: _, good: _}, opts \\ %{}) do
    Sparklinex.Bullet.draw(data, struct(%Sparklinex.Bullet.Options{}, opts))
  end

  @doc """
  """
  def graph_to_file(img = %Mogrify.Image{}, path) do
    {:ok, file} = File.open(path, [:write])
    IO.binwrite(file, graph_to_binary(img))
    File.close(file)
  end

  @doc """
  """
  def graph_to_binary(img = %Mogrify.Image{}) do
    img
    |> Mogrify.custom("stdout", "png:-")
    |> Mogrify.create(buffer: true)
    |> Map.fetch!(:buffer)
  end
end
