defmodule Heron.Project do
  require Logger

  defstruct name: "", src: "src", bld: "bld", type: "native"

  ######## INFORMATION COLLECTION #######
  def info do
    git_status |> git_worktree 
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

  def git_status do
    case System.cmd("git", ["status"], []) do
      {return, 0} ->
        [_, branch] = Regex.run(~r/^On branch (.*?)\n/, return)
        {:ok, branch}
      _ -> {:error, "NONE"}
    end
  end

  def git_worktree({:ok, branch}) do
    {return, 0} = System.cmd("git", ["worktree", "list"], [])

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

  def git_worktree({:error, none}) do
    Logger.warn("Current working directory is not a Git repository")
    {none, [{Path.expand("."), none}]}
  end

  ############# ADD PROJECT #################

  def add_project(args, nil) do
    add_project(args, Path.expand("~/.config/heron"))
  end

  def add_project([name, src, bld, type], cache) do
    Logger.info("Adding project to cache")
    {:ok, projects} = Cachex.get(:heron, :projects)
    {:ok, true} = Cachex.put(:heron, :projects,
      Map.put(projects, name, 
        %Heron.Project{
          name: name,
          src: src,
          bld: bld,
          type: type}))
    Cachex.dump(:heron, Path.join(cache, "heron.db"))
  end
  

  #################### RUN OPERATIONS ################
  def run(opts, []) do
    {:ok, projects} = Cachex.get(:heron, :projects)
    IO.inspect projects
  end

  def run(opts, ["add" | args]) do
    add_project(args, opts[:cache])
  end

  def run(opts, args) do
    Logger.error "Unsupported project command: #{IO.inspect args}"
  end
end
