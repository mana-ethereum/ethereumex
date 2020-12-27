defmodule Ethereumex.ConfigTest do
  use ExUnit.Case
  use WithEnv

  describe ".setup_children" do
    test ":ipc returns a list with 1 worker pool" do
      with_env put: [
                 ethereumex: [
                   ipc_worker_size: 3,
                   ipc_max_worker_overflow: 4,
                   ipc_request_timeout: 5,
                   ipc_path: "/tmp/socket.ipc"
                 ]
               ] do
        specs = Ethereumex.Config.setup_children(:ipc)

        assert Enum.count(specs) == 1

        assert Enum.at(specs, 0) ==
                 :poolboy.child_spec(
                   :worker,
                   [
                     {:name, {:local, :ipc_worker}},
                     {:worker_module, Ethereumex.IpcServer},
                     {:size, 3},
                     {:max_overflow, 4}
                   ],
                   path: "#{System.user_home!()}/tmp/socket.ipc",
                   ipc_request_timeout: 5
                 )
      end
    end

    test ":http has no supervised children" do
      assert Ethereumex.Config.setup_children(:http) == []
    end

    test "unsupported client types raise an error" do
      assert_raise(
        RuntimeError,
        "Invalid :client option (not_supported) in config",
        fn ->
          Ethereumex.Config.setup_children(:not_supported)
        end
      )
    end

    test "defaults to the configured client_type" do
      with_env put: [ethereumex: [client_type: :http]] do
        assert Ethereumex.Config.setup_children() == []
      end
    end
  end

  describe ".rpc_url" do
    test "returns the application configured value" do
      with_env put: [ethereumex: [url: "http://foo.com"]] do
        assert Ethereumex.Config.rpc_url() == "http://foo.com"
      end
    end

    test "raises an error when not present" do
      with_env put: [ethereumex: [url: ""]] do
        assert_raise(
          ArgumentError,
          "Please set config variable `config :ethereumex, :url, \"http://...\", got: `\"\"`",
          fn -> Ethereumex.Config.rpc_url() end
        )
      end
    end
  end

  describe ".ipc_path" do
    test "returns the application configured value" do
      with_env put: [ethereumex: [ipc_path: "/tmp/socket.ipc"]] do
        assert Ethereumex.Config.ipc_path() == "/tmp/socket.ipc"
      end
    end

    test "raises an error when not present" do
      with_env put: [ethereumex: [ipc_path: ""]] do
        assert_raise(
          ArgumentError,
          "Please set config variable `config :ethereumex, :ipc_path, \"path/to/ipc\", got ``. Note: System.user_home! will be prepended to path for you on initialization",
          fn -> Ethereumex.Config.ipc_path() end
        )
      end
    end
  end

  describe ".http_options" do
    test "returns the application configured value" do
      with_env put: [ethereumex: [http_options: [timeout: 8000]]] do
        assert Ethereumex.Config.http_options() == [timeout: 8000]
      end
    end

    test "returns an empty list by default" do
      with_env delete: [ethereumex: [:http_options]] do
        assert Ethereumex.Config.http_options() == []
      end
    end
  end

  describe ".client_type" do
    test "returns the application configured value" do
      with_env put: [ethereumex: [client_type: :ipc]] do
        assert Ethereumex.Config.client_type() == :ipc
      end
    end

    test "returns http by default" do
      with_env delete: [ethereumex: [:client_type]] do
        assert Ethereumex.Config.client_type() == :http
      end
    end
  end
end
