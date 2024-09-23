require "wasmtime"

class HomeController < ApplicationController
  def index
    plugin_path = Rails.root.join('lib', 'plugins/example.wasm').to_s
    fun_params = { name: params.fetch(:name,"John") }

    engine = Wasmtime::Engine.new
    mod = Wasmtime::Module.from_file(engine, plugin_path)

    output_buffer = String.new
    buffer_size = 1024 * 1024

    wasi_ctx = Wasmtime::WasiCtxBuilder.new
      .set_stdin_string(fun_params.to_json)
      .set_stdout_buffer( output_buffer, buffer_size)
      .inherit_stderr
      .set_argv(ARGV)
      .set_env(ENV)
      .build
    store = Wasmtime::Store.new(engine, wasi_ctx: wasi_ctx)

    linker = Wasmtime::Linker.new(engine, wasi:true)
    instance = linker.instantiate(store, mod)
    instance.invoke("_start")

    @message = output_buffer
  end
end
