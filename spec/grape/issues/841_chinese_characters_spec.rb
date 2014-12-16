# encoding: utf-8
require 'spec_helper'

describe Grape::API do
  subject do
    Class.new(Grape::API) do
      format :json
      get do
        { test: "哈哈哈" }
      end
    end
  end

  def app
    subject
  end

  it 'correctly encodes Chinese characters' do
    get '/'
    expect(last_response.status).to eq 200
    expect(last_response.body).to eq({ test: "哈哈哈" }.to_json)
  end
end
