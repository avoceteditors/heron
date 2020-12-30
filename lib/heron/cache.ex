defmodule Heron.Cache do

  require Logger


  def init_cache(path, cache) do
    # Load Projects
    Logger.debug("Initialize default projects")
    Cachex.put(:heron, :projects, %{})

    if not File.exists?(path) do
      Logger.debug("Cache directory does not exist, creating")
      File.mkdir_p(path)
    end

    Logger.debug("Dumping default configuration")
    {:ok, true} = Cachex.dump(:heron, cache)
    :ok
  end


  def load_cache(nil, force) do
    load_cache(Path.expand("~/.config/heron"), force)
  end

  def load_cache(path, force) do
    Logger.info("Loading cache from #{path}")

    cache = Path.join(path, "heron.db")
    if force do
      init_cache(path, cache)
    else
      case Cachex.load(:heron, cache) do
        {:ok, true} -> Logger.debug("Cache loaded")
        {:error, :unreachable_file} ->
          Logger.info("Unable to load cache, creating from scratch")
          init_cache(path, cache)
      end
    end
  end


end
