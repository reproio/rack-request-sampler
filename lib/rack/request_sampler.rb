require "rack"

class Rack::RequestSampler
  def initialize(app)
    @app = app
  end

  def call(env)
    Rack::RequestSampler.config.handlers.each do |handler|
      handler.call(env)
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

    def on_picked_up=(options)
      raise ArgumentError.new unless options.is_a? Array
      options = [options] unless options[0].is_a? Array

      options.each do |option|
        @handlers << Handler.new(option[0][:numerator], option[0][:denominator], &option[1])
      end
    end
  end

  class Handler
    def initialize(numerator, denominator, &block)
      @numerator = numerator
      @denominator = denominator
      @block = block
      @random = Random.new
    end

    def call(env)
      @block.call env.dup if @random.rand(@denominator) < @numerator
    end
  end
end
