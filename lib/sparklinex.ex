defmodule Sparklinex do
  alias Sparklinex.{Smooth, Bar, Bullet, Whisker}

  @moduledoc """
  Documentation for Sparklinex.
  """

  @doc """
  """
  def graph(data_points, opts = %{type: type}) do
    graph_opts = Map.drop(opts, [:type])

    case type do
      :smooth -> smooth(data_points, struct(%Smooth.Options{}, graph_opts))
      :bar -> bar(data_points, struct(%Bar.Options{}, graph_opts))
      :bullet -> bullet(data_points, struct(%Bullet.Options{}, graph_opts))
      :whisker -> whisker(data_points, struct(%Whisker.Options{}, graph_opts))
    end
  end

  @doc """
  """
  def smooth(data_points, opts \\ %Smooth.Options{}) do
    Smooth.draw(data_points, opts)
  end

  @doc """
  """
  def bar(data_points, opts \\ %Bar.Options{}) do
    Bar.draw(data_points, opts)
  end

  @doc """
  """
  def bullet(data = %{value: _, good: _}, opts \\ %Bullet.Options{}) do
    Bullet.draw(data, opts)
  end

  @doc """
  """
  def whisker(data, opts \\ %Whisker.Options{}) do
    Whisker.draw(data, opts)
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
