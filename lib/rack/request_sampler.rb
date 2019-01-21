require "rack"

class Rack::RequestSampler
  def initialize(app)
    @app = app
  end

  def call(env)
    Rack::RequestSampler.config.handlers.each do |handler|
      handler.call(env.dup)
    end

    @app.call(env)
  end

  def self.config
    @config ||= Config.new
  end

  class Config
    attr_reader :handlers

    def initialize
      @handlers = []
    end

    def on_sampled(ratio:, &block)
      @handlers << Handler.new(ratio, &block)
    end
  end

  class Handler
    def initialize(ratio, &block)
      @ratio = ratio
      @block = block
    end

    def call(env)
      @block.call(env) if rand <= @ratio
    end
  end
end
