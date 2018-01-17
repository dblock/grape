require 'spec_helper'

describe Grape::Endpoint do
  subject { Class.new(Grape::API) }

  def app
    subject
  end

  before do
    subject.format :json
    subject.params type: Array do
      requires :foo, type: String
    end
    subject.post do
      p params
      params
    end
  end

  let(:data) { ::Grape::Json.dump([{ foo: 'bar' }, { foo: 'baz' }]) }

  it 'responds' do
    post '/', data, 'CONTENT_TYPE' => 'application/json'
    expect(last_response.status).to eq 201
    expect(last_response.body).to eq(data)
  end
end
