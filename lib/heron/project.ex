defmodule Heron.Project do
  require Logger

  defstruct name: "", src: "src", bld: "bld", type: "native"

  ######## INFORMATION COLLECTION #######
  def info do
    info Path.expand(".")
  end

  def info(nil) do
    info Path.expand(".")
  end

  def info cwd do
    git_status(cwd) |> git_worktree |> git_struct
  end

  def git_struct({current_branch, worktrees}) do
    {current_branch, 
      Enum.map(worktrees, 
        fn {path, branch} ->
          {branch, %Heron.Worktree{branch: branch, path: path}}
        end)
        |> Map.new(fn {k, v} -> {k, v} end)
    }
  end

  def git_status(cwd) do
    case System.cmd("git", ["status"], [cd: cwd]) do
      {return, 0} ->
        [_, branch] = Regex.run(~r/^On branch (.*?)\n/, return)
        {:ok, branch, cwd}
      _ -> {:error, "NONE", cwd}
    end
  end

  def git_worktree({:ok, branch, cwd}) do
    {return, 0} = System.cmd("git", ["worktree", "list"], [cd: cwd])

    wt = Regex.split(~r/\s*\n\s*/, return)
    |> Enum.filter(fn x ->
      x != ""
    end)
    |> Enum.map(fn x ->
      [base, path, _, branch] = Regex.run(~r/(\/.*?) (.*?) \[(.*?)]/, x)

      {path, branch}
    end)
    {branch, wt}
  end

  def git_worktree({:error, none, cwd}) do
    Logger.warn("Current working directory is not a Git repository")
    {none, [{Path.expand(cwd), none}]}
  end

  #################### RUN OPERATIONS ################
  def run(opts, []) do
    {:ok, projects} = Cachex.get(:heron, :projects)
    IO.inspect projects
  end

  def run(opts, args) do
    Logger.error "Unsupported project command: #{IO.inspect args}"
  end
end
