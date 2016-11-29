require "nokogiri"
require "daimon_skycrawlers/crawler"

module DaimonSkycrawlers
  module Processor
    class Spider < Base
      attr_accessor :enqueue, :link_rules, :next_page_link_rules

      def initialize
        super
        @link_filters = []
        @doc = nil
        @links = nil
        @enqueue = true
        @link_rules = ["a"]
        @extract_link = ->(element) { element["href"] }
        @next_page_link_rules = nil
        @extract_next_page_link = ->(element) { element["href"] }
      end

      def configure
        yield self
      end

      def append_link_filter(filter = nil, &block)
        if block_given?
          @link_filters << block
        else
          @link_filters << filter if filter.respond_to?(:call)
        end
      end

      def extract_link(&block)
        @extract_link = block
      end

      def extract_next_page_link(&block)
        @extract_next_page_link = block
      end

      #
      # @param [Hash] message Must have key :url, :depth
      #
      def call(message)
        key_url = message[:url]
        depth = Integer(message[:depth] || 2)
        return if message[:heartbeat]
        return if depth <= 1
        page = storage.find(key_url)
        @doc = Nokogiri::HTML(page.body)
        new_message = {
          depth: depth - 1,
        }
        links.each do |url|
          enqueue_url(url, new_message)
        end
        next_page_url = find_next_page_link
        if next_page_link
          enqueue_url(next_page_url, new_message)
        end
      end

      private

      def links
        return @links if @links
        @links = retrieve_links
        @links
      end

      def retrieve_links
        urls = @doc.search(*link_rules).map do |element|
          @extract_next_page_link.call(element)
        end
        urls.uniq!
        apply_link_filters(urls) || []
      end

      def next_page_link
        return unless next_page_link_rules
        element = @doc.at(*next_page_link_rules)
        return unless element
        @extract_next_page_link.call(element)
      end

      def apply_link_filters(urls)
        return if urls.nil?
        return if urls.empty?
        log.debug("Candidate URLs: #{urls.size}")
        urls = urls.select do |url|
          @link_filters.all? {|filter| filter.call(url) }
        end
        log.debug("Filtered URLs: #{urls.size}")
        urls
      end

      def enqueue_url(url, new_message)
        return unless @enqueue
        log.debug("Enqueue: URL:#{url}, message: #{new_message}")
        DaimonSkycrawlers::Crawler.enqueue_url(url, new_message)
      end
    end
  end
end
