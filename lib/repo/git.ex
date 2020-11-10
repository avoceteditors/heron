defmodule Heron.Repo.Git do
  require Logger

  @moduledoc """
  Module containing functions for retrieving infromation on Git repositories.
  """

  @doc """
  Returns indicator that the given path is valid.

  Valid Git repositories feature a `.git/` directory at the base path
  of the repository.  This functionc hecks that the given path has a `.git/`
  directory to identify valid repositories.
  """
  def valid(path) do
    File.exists?(Path.join(path, ".git"))
  end

  @doc """
  Returns the status of the Git repository.

  This function passes the `:status` atom with the given path
  to the `query/1` function.  If the path is valid, returns a
  map with the given path and the evaluated status results.
  """
  def status(dirty_path) do
    path = Path.expand(dirty_path)
    query(:status, path, valid(path))
  end

  @status_vals [
    {:uptodate, ~r{Your branch is up to date with}},
    {:behind, ~r{Your branch is behind}},
    {:ahead, ~r{Your branch is ahead}},
    {:unstaged, ~r{Changes not staged for commit}},
    {:untracked, ~r{Untracked files}}
  ]

  @doc """
  Evaluates Git status message

  Function takes the results of `git status` output and runs 
  it against a series of Regular Expression patterns to determine
  what information is set in the output (id est, whether the status
  message mentiosn the repo being up-to-date, behind, ahead, or
  containing unstaged or untracked files).
  """
  def eval_status(status) do
    eval_status(status, @status_vals)
  end

  def eval_status(status, vals) do
    case vals do
      [{stat, check} | rest] ->
        if String.match?(status, check) do
          [stat | eval_status(status, rest)]
        else
          eval_status(status, rest)
        end

      _ ->
        []
    end
  end

  @doc """
  Runs a query against a Git repository in the given directory.
  """
  def query(:status, path, valid_repo) when valid_repo do
    case System.cmd("git", ["status"], cd: path) do
      {status, 0} -> %{path: path, status: eval_status(status)}
      {error, ret} -> Logger.error("Status returns error (#{ret}): #{error}")
      _ -> Logger.error("Error reading repository")
    end
  end

  def query(_cmd, path, valid_repo) when not valid_repo do
    Logger.error("Path #{path} is not a valid Git repository")
  end
end
