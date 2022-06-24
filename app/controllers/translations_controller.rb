require 'rubygems'
require 'excon'

class TranslationsController < ApplicationController
  before_action :set_defaults

  def index; end

  def translate_params
    params.permit(:source, :source_language, :destination_language)
  end

  def translate
    @source = translate_params[:source]
    @source_language = translate_params[:source_language]
    @destination_language = translate_params[:destination_language]

    body = {
      q: @source,
      target: @destination_language.upcase
    }

    body[:source] = @source_language.downcase unless @source_language.empty?

    translation = api_request(
      'language/translate/v2',
      method: :post,
      body: URI.encode_www_form(body)
    )

    @translation = translation['data']['translations'].first['translatedText']

    render action: :index
  end

  private

  def set_defaults
    @languages = fetch_languages
  end

  def api_request(path, method: :get, body: nil)
    params = {
      headers: {
        'x-rapidapi-key': '198da2095cmshebebd35e768f64ap1c1372jsne4ce6199fe1c',
        'content-type': 'application/x-www-form-urlencoded'
      }
    }

    params[:body] = body if body

    response = Excon.send(method,
                          "https://google-translate1.p.rapidapi.com/#{path}",
                          params)

    JSON.parse(response.body)
  end

  def fetch_languages
    languages = api_request('language/translate/v2/languages')
    print('languages')

    keys = languages['data']['languages'].map { |l| l['language'].upcase }

    I18nData
      .languages
      .slice(*keys)
      .each_with_object([]) do |(iso, name), memo|
        memo << [name, iso]
      end
  end
end
