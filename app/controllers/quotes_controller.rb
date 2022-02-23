class QuotesController < ApplicationController

  include ActionController::HttpAuthentication::Token::ControllerMethods
  
  URL = "https://quotes.toscrape.com"

  #before_action :authentificate
  before_action :set_quote, only: [:show, :update, :destroy]
  before_action :set_quotes, only: [:search_quotes]

  # GET /quotes
  def index
    @quotes = Quote.all

    render json: @quotes 
  end

  # GET /quotes/1
  def show
    render json: @quote
  end

  # POST /quotes
  def create
    @quote = Quote.new(quote_params)

    if @quote.save
      render json: @quote, status: :created, location: @quote
    else
      render json: @quote.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /quotes/1
  def update
    if @quote.update(quote_params)
      render json: @quote
    else
      render json: @quote.errors, status: :unprocessable_entity
    end
  end

  # DELETE /quotes/1
  def destroy
    @quote.destroy
  end

  # Get /quotes/tag
  def search_quotes
    if @quotes.empty?
      render json: {status: "404", error: "tag not found"}, status: :not_found
    else
      render json: @quotes
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quote
      @quote = Quote.find(params[:id])
    end

    def search_tag
      tag = Tag.find_by(name: params[:tag])
    end

    def set_new_tag
      Tag.create!(
        name: params[:tag]
      )
    end

    def get_related_tags(quote, tags_array)
      quote.search('.tag').each do |tag|
        tags_array.push(tag.text)
      end
    end


    def set_quotes

      begin 
        tag = search_tag
        @quotes = Quote.where(tag: tag).to_a
      rescue
        @quotes = screpe_quote
      end
    
    end

    def screpe_quote

      require 'nokogiri'
      require 'open-uri'

      url_search = URL+"/tag/#{params[:tag]}/"

      doc = Nokogiri::HTML(URI.open(url_search))
      
      tag_created = set_new_tag

      quotes_search = Array.new()

      doc.search('.quote').each do |quote|

        small = quote.at('.author')
        a = quote.at('a/@href')
        
        get_related_tags quote, related_tags_array = []

        quotes_search <<  Quote.create!(
                              tag: tag_created,
                              quote: quote.at('.text').text,
                              author: small.text,
                              author_about: URL + a.text,
                              tags: related_tags_array
                          )

      end

      quotes_search

    end

    # Only allow a list of trusted parameters through.
    def quote_params
      ActiveModelSerializers::Deserialization.jsonapi_parse(params)
    end


    def authentificate
      authenticate_or_request_with_http_token do  |token, options|
        #hmac_secret = 'my$ecretK3y'
        JWT.decode token, Auth::HMAC_SECRET, true, { algorithm: 'HS256' }
      end
    end


end
