require 'spec_helper'

describe Grape::API do
  let(:jobs_api) {
    Class.new(Grape::API) do
      namespace :jobs do
        params do
          requires :job_id, type: String
        end
        route_param :job_id do
          namespace :im do
            params do
              optional :user_id, type: Integer
              optional :edge_timestamp, type: DateTime
            end
            get :updates do
              true
            end

            params do
              optional :user_id, type: Integer
              optional :edge_timestamp, type: DateTime
            end
            get :history do
              true
            end

            params do
              optional :message, type: String
              optional :user_id, type: Integer
            end
            post do
              true
            end

            get :dialogs do
              true
            end
          end
        end
      end
    end
  }

  let(:combined_api) {
    JobsApi = jobs_api
    Class.new(Grape::API) do
      version :v1, using: :accept_version_header, cascade: true
      mount JobsApi
    end
  }

  subject {
    CombinedApi = combined_api
    Class.new(Grape::API) do
      format :json

      mount CombinedApi => '/'
    end
  }

  def app
    subject
  end

  it 'execute first request in reasonable time' do
    started = Time.now
    get '/mount1/nested/test_method'
    expect(Time.now - started).to be < 5
  end
end
