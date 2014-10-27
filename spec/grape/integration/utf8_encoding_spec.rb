# -*- encoding : utf-8 -*-
# https://github.com/intridea/grape/issues/786

require 'spec_helper'
require 'shared/versioning_examples'

describe Grape::API do
  module EncodingSpec
    class API < Grape::API
      params do
        requires :a
        requires :b
        optional :file, type: Rack::Multipart::UploadedFile
      end
      post do
        [
          params[:a].encoding,
          params[:b].encoding,
          parmas[:file] ? params[:file].encoding : nil
        ].compact.map(&:to_s).join(",")
      end
    end
  end

  subject { EncodingSpec::API.new }

  def app
    subject
  end

  describe 'encoding' do
    it 'uses UTF-8 encoding for UTF-8 strings' do
      post '/', a: "aaa", b: "😈"

      expect(last_response.body).to eq("UTF-8,UTF-8")
    end

    it 'uses UTF-8 encoding for UTF-8 strings also when sending a file' do
      header 'Content-Type', 'multipart/form-data'
      post '/', a: "aaa", b: "😈", file: Rack::Test::UploadedFile.new("grape.png", 'image/png', true)

      expect(last_response.body).to eq("UTF-8,UTF-8")
    end

    it 'uses UTF-8 encoding for UTF-8 strings also when sending a file and charset=UTF-8 content type' do
      header 'Content-Type', 'multipart/form-data; charset=UTF-8'
      post '/', a: "aaa", b: "😈", file: Rack::Test::UploadedFile.new("grape.png", 'image/png', true)

      expect(last_response.body).to eq("UTF-8,UTF-8")
    end
  end
end
