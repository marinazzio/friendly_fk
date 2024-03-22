module ARTest
  class << self
    def connect
      ActiveRecord::Base.establish_connection connection_string_or_config
    end

    private

    def connection_string_or_config
      ENV.fetch('TEST_DATABASE_URL', nil) || config[ENV.fetch('DB', 'postgres')]
    end

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
