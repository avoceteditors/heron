defmodule Heron.Reader do

  def expand(base_path, paths) do
    case paths do
      [path | rest] ->
        name = "#{base_path}/#{path}"
        if File.dir?(name) do
          {:ok, contents} = File.ls(name)
          expand(name, contents) ++ expand(base_path, rest)
        else
          # Collect Metadata
          {:ok, stat} = File.lstat(name)
          ext = Path.extname(name)
          
          # Return Content
          [Heron.Source.read(name, stat, ext) | expand(base_path, rest)]
        end
      [] -> []
    end
  end

  def expand(src) do
    if File.dir?(src) do
      {:ok, contents} = File.ls(src)
      expand(src, contents)
    else
      [src]
    end
  end

  def read_wt(branch, wt, src) do
    source = Path.join(wt.path, src)
    |> expand
    
    {branch, source}
  end

  def read_files({branch, worktrees}, src, true) do
    cur = self()
    worktrees
    |> Enum.map(fn {branch, wt} ->
      spawn_link fn -> (send cur, {self(), read_wt(branch, wt, src)})
      end
    end)
    |> Enum.map(fn pid ->
      receive do {^pid, result} -> result
      end
    end)
  end

  def read_files({branch, worktrees}, src, nil) do
    [read_wt(branch, Map.get(worktrees, branch), src)]
  end

  def run(opts, [src]) do
    Heron.Project.info(opts[:cwd])
    |> read_files(src, opts[:all])
  end
end
