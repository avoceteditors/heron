defmodule Heron.Reader do


  def read_wt(wt, src) do
    Path.join(wt.path, src)
    |> expand_files
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
