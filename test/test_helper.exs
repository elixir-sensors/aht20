# Always warning as errors
if Version.match?(System.version(), "~> 1.10") do
  Code.put_compiler_option(:warnings_as_errors, true)
end

Application.put_env(:aht20, :transport_module, AHT20.MockI2C)
Mox.defmock(AHT20.MockI2C, for: AHT20.Transport)

ExUnit.start()
