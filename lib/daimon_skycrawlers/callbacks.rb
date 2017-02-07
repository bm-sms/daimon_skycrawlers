module DaimonSkycrawlers
  #
  # This module provides simple callback system
  #
  module Callbacks
    # @private
    def initialize
      super
      @before_process_callbacks = []
      @after_process_callbacks = []
    end

    #
    # Register before process callback
    #
    # @param callback [Object] This object must respond to call
    # @yield [message]
    # @yieldparam message [Hash]
    #
    def before_process(callback = nil, &block)
      if block_given?
        @before_process_callbacks << block
      else
        @before_process_callbacks << callback if callback.respond_to?(:call)
      end
    end

    #
    # Run registered before process callbacks
    #
    def run_before_process_callbacks(message)
      @before_process_callbacks.all? do |callback|
        callback.call(message)
      end
    end

    #
    # Clear all before process callbacks
    #
    def clear_before_process_callbacks
      @before_process_callbacks = []
    end

    #
    # Register after process callback
    #
    # @param callback [Object] This object must respond to call
    # @yield [message]
    # @yieldparam message [Hash]
    #
    def after_process(callback = nil, &block)
      if block_given?
        @after_process_callbacks << block
      else
        @after_process_callbacks << callback if callback.respond_to?(:call)
      end
    end

    #
    # Run registered before process callbacks
    #
    def run_after_process_callbacks(message)
      @after_process_callbacks.each do |callback|
        callback.call(message)
      end
    end

    #
    # Clear all after process callbacks
    #
    def clear_after_process_callbacks
      @after_process_callbacks = []
    end
  end
end
