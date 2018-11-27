require "rack/test"
require "byebug"

RSpec.describe Rack::Request::Sampler do
  include Rack::Test::Methods

  class TestApp
    def call(env)
      [ 200, { "Content-Type" => "text/plain;charset=utf-8", "Content-Length"  => "6" }, [ "Hello!" ]]
    end
  end

  class Dog
    def play(env)
      env["SERVER_NAME"] = "dog.example.com"
    end
  end

  class Cat
    def play(env)
      "miaows"
    end
  end

  let(:test_app) { TestApp.new }
  let(:app) { Rack::Request::Sampler.new test_app }
  let(:dog) { Dog.new }
  let(:cat) { Cat.new }

  it "has a version number" do
    expect(Rack::Request::Sampler::VERSION).not_to be nil
  end

  context "single configuration" do
    before {
      allow(dog).to receive(:play).with(anything)

      Rack::Request::Sampler.config.on_picked_up = { numerator: 1, denominator: 1 }, Proc.new do |env|
        dog.play env
      end
    }

    it "does not change the original response and the request" do
      get '/'

      expect(dog).to have_received(:play).with(anything).once

      expect(last_response.status).to eq 200
      expect(last_response.body).to eq "Hello!"
      expect(last_response.header["Content-Type"]).to eq "text/plain;charset=utf-8"
      expect(last_response.header["Content-Length"]).to eq "6"

      expect(last_request.env["SERVER_NAME"]).to eq "example.org"
    end
  end

  context "multiple configurations" do
    before {
      allow(dog).to receive(:play).with(anything)
      allow(cat).to receive(:play).with(anything)

      Rack::Request::Sampler.config.on_picked_up = { numerator: 1, denominator: 1 }, Proc.new do |env|
        dog.play env
      end

      Rack::Request::Sampler.config.on_picked_up = { numerator: 1, denominator: 1 }, Proc.new do |env|
        dog.play env
        cat.play env
      end
    }

    it "applies the all configuratinons" do
      get '/'

      expect(dog).to have_received(:play).with(anything).twice
      expect(cat).to have_received(:play).with(anything).once
    end
  end
end
