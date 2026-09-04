# frozen_string_literal: true

describe Grape::Middleware::DeprecatedOptionsHashAccess do
  let(:data_class) do
    Data.define(:foo) do
      include Grape::Middleware::DeprecatedOptionsHashAccess
    end
  end
  let(:instance) { data_class.new(foo: 'bar') }

  it 'warns that the Hash-style accessor is deprecated' do
    expect(Grape.deprecator).to receive(:warn).with(/`#{data_class.name}#\[\]` is deprecated/)
    instance[:foo]
  end

  it 'forwards to the named accessor when the member exists' do
    allow(Grape.deprecator).to receive(:warn)
    expect(instance[:foo]).to eq('bar')
  end

  it 'returns nil when the member does not exist' do
    allow(Grape.deprecator).to receive(:warn)
    expect(instance[:missing]).to be_nil
  end
end
