defmodule Heron.Reader do


  def expand_files(path) do
    if File.dir?(path) do
      {:ok, paths} = File.ls(path)
      expand_files(path, paths)
    else
      [path]
    end
  end

  def expand_files(base_path, paths) do
    case paths do
      [path | rest] ->
        name = "#{base_path}/#{path}"
        if File.dir?(path) do
          {:ok, contents} = File.ls(name)
          [expand_files(name, contents) | expand_files(base_path, rest)]
        else
          [name | expand_files(base_path, rest)]
        end
      [] -> []
    end
  end

  def expand(paths) do
    case paths do
      [path | rest] ->
        [expand_files(path) | expand(rest)]
      [] -> []
    end
  end

  def read_wt(wt, src) do
    [Path.join(wt.path, src)]
    |> expand
    
  end

  def read({branch, worktrees}, src, true) do
    cur = self()
    worktrees
    |> Enum.map(fn {branch, wt} ->
      spawn_link fn -> (send cur, {self(), read_wt(wt, src)})
      end
    end)
    |> Enum.map(fn pid ->
      receive do {^pid, result} -> result
      end
    end)
  end

  def read({branch, worktrees}, src, nil) do
    [read_wt(Map.get(worktrees, branch), src)]
  end

  def run(opts, [src]) do
    Heron.Project.info(opts[:cwd])
    |> read(src, opts[:all])
    |> IO.inspect
  end
end
