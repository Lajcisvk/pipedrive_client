require 'typhoeus'
require 'json'
require 'yaml'
require 'helpers/pipedrive_helpers'

module Pipedrive
  class Client
    using PipedriveHelpers

    PIPELINE_HOST = 'https://api.pipedrive.com/v1/'

    def initialize(path, parameters = {})
      @api_path = path
      @parameters = parameters
      @parameters[:query] ||= {}
      @parameters[:query][:limit] ||= 500
      @parameters[:query][:start] ||= 0
    end

    def get
      fetch_all
    end

  private

    def create_api_url
      url = "#{PIPELINE_HOST}#{@api_path}"
      url += "/#{@parameters[:id]}" if @parameters[:id]
      url += "/#{@parameters[:method]}" if @parameters[:method]
      token_query = { api_token: api_key }
      if @parameters[:query]
        @parameters[:query].merge!(token_query)
      else
        @parameters[:query] = token_query
      end
      "#{url}?" \
      "#{@parameters[:query].map { |key, value| "#{key}=#{value}" }.join('&')}"
    end

    def fetch
      url = create_api_url
      tries = 3
      response = nil
      loop do
        break if tries.zero?
        tries -= 1
        response = Typhoeus.get(url)
        response.response_headers =~ /X-RateLimit-Remaining: (\d+)/
        check_limit(response.response_headers)
        next if response.response_code != 200
        response = JSON.parse(response.body)
        break if response['success']
      end
      response
    end

    def fetch_all
      all_data = []
      loop do
        response = fetch
        return nil unless data_ok?(response)
        data = response['data']
        all_data += data.is_a?(Array) ? data : [data]
        unless response['additional_data'].present? &&
               response['additional_data']['pagination'].present? &&
               response['additional_data']['pagination']['more_items_in_collection']
          break
        end
        @parameters[:query][:start] += @parameters[:query][:limit]
      end
      all_data
    end

    def check_limit(headers)
      headers =~ /X-RateLimit-Remaining: (\d+)/
      return unless Regexp.last_match(1) == '0'
      headers =~ /X-RateLimit-Reset: (\d+)/
      sleep(Regexp.last_match(1).to_i)
    end

    def data_ok?(data)
      data.is_a?(Hash) && data['success'] && data['data']
    end

    def api_key
      return @api_key if @api_key
      @api_key = YAML.load(
        File.read(
          File.expand_path('pipedrive_key.yml', 'config')
        )
      )[:api_key]
    end
  end
end
