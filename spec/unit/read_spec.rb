RSpec.describe TTY::Config, '#read', type: :cli do
  it "reads from a specified file" do
    file = fixtures_path('investments.yml')
    config = TTY::Config.new

    config.read(file)

    expect(config.fetch('settings', 'base')).to eq('USD')
  end

  it "searched for a file to read from" do
    config = TTY::Config.new
    config.filename = 'investments'
    config.append_path(fixtures_path)

    config.read

    expect(config.fetch('settings', 'base')).to eq('USD')
  end

  it "reads from a specified file and merges with defaults" do
    file = fixtures_path('investments.yml')
    config = TTY::Config.new
    config.set('settings', 'base', value: 'EUR')
    config.set('settings', 'top', value: 50)

    config.read(file)

    expect(config.fetch('settings', 'base')).to eq('USD')
    expect(config.fetch('settings', 'exchange')).to eq('CCCAGG')
    expect(config.fetch('settings', 'top')).to eq(50)
  end

  it "fails to find a file to read" do
    config = TTY::Config.new
    expect {
      config.read
    }.to raise_error(TTY::Config::LoadError,
                    "No file found to read configuration from!")
  end

  it "fails to read a file" do
    config = TTY::Config.new
    file = fixtures_path('unknown.yml')

    expect {
      config.read(file)
    }.to raise_error(TTY::Config::LoadError,
                    "Configuration file `#{file}` does not exist!")
  end
end
