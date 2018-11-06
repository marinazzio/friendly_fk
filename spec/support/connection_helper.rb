module ARTest
  class << self
    def connect
      ActiveRecord::Base.establish_connection config[ENV['DB'] || 'postgres']
    end

    private

    def config
      @config ||= read_config
    end

    def config_file
      Pathname.new('spec/database.yml')
    end

    def read_config
      YAML.parse(ERB.new(config_file.read).result).transform
    end
  end
end
