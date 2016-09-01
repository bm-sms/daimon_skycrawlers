require "nokogiri"

module DaimonSkycrawlers
  module Processor
    class Spider < Base
      def initialize
        @filters = []
        @doc = nil
        @links = nil
      end

      def append_filter(filter = nil, &block)
        if block_given?
          @filters << block
        else
          @filters << filter
        end
      end

      #
      # @param [Hash] message Must have key :url, :depth, :interval
      #
      def call(message)
        key_url = message[:url]
        depth = message[:depth]
        interval = message[:interval]
        return if depth <= 1
        page = storage.find(key_url)
        @doc = Nokogiri::HTML(page.body)
        new_message = {
          depth: depth - 1,
          interval: interval
        }
        links.each do |url|
          DaimonSkycrawlers::Crawler.enqueue_url(url, new_message)
        end
      end

      private

      def links
        return @links if @links
        @links = retrieve_links
        @links
      end

      def retrieve_links
        urls = @doc.search("a").map do |element|
          element["href"]
        end
        apply_filters(urls) || []
      end

      def apply_filters(urls)
        return if urls.nil?
        return if urls.empty?
        @filters.each do |filter|
          urls = urls.select do |url|
            filter.call(url)
          end
        end
        urls
      end
    end
  end
end
