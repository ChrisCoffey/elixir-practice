defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank() do
    {:ok, account} = Agent.start_link(fn -> 0 end)
    account
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account) do
    Agent.stop(account)
    #account |> if_open(fn -> Process.exit(account, :normal) end)
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do
    account |> if_open(fn -> Agent.get(account, fn balance -> balance end) end)
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount) do
    account |> if_open(fn -> Agent.update(account, fn x -> x + amount end) end)
  end

  defp if_open(account, f) do
    if Process.info(account) do
      f.()
    else
      {:error, :account_closed}
    end
  end
end
