defmodule MyCommand do
  use Bender.Command

  def handle_event({{:command, "my_command", _m}, _conf}, parent) do
    send parent, :MY_COMMAND
    {:ok, parent}
  end
end

defmodule Bender.CommandTest do
  use ExUnit.Case

  test "it pattern matches a command" do
    {:ok, manager} = GenEvent.start_link
    GenEvent.add_handler(manager, MyCommand, self())

    GenEvent.notify(manager, {{:command, "my_command", "hello world"}, {}})
    assert_receive :MY_COMMAND, 100
  end

  test "does not crash for commands that don't match" do
    {:ok, manager} = GenEvent.start_link
    GenEvent.add_handler(manager, MyCommand, self())

    :ok = GenEvent.sync_notify(manager, {{:command, "unknown_command", "hello world"}, {}})
    assert GenEvent.which_handlers(manager) == [MyCommand]
  end
end
