module DaimonSkycrawlers
  module Callbacks
    def initialize
      super
      @before_process_callbacks = []
      @after_process_callbacks = []
    end

    def before_process(callback = nil, &block)
      if block_given?
        @before_process_callbacks << block
      else
        @before_process_callbacks << callback if callback.respond_to?(:call)
      end
    end

    def run_before_callbacks(message)
      @before_process_callbacks.all? do |callback|
        callback.call(message)
      end
    end

    def clear_before_process_callbacks
      @before_process_callbacks = []
    end

    def after_process(callback = nil, &block)
      if block_given?
        @after_process_callbacks << block
      else
        @after_process_callbacks << callback if callback.respond_to?(:call)
      end
    end

    def run_after_callbacks(message)
      @after_process_callbacks.each do |callback|
        callback.call(message)
      end
    end

    def clear_after_process_callbacks
      @after_process_callbacks = []
    end
  end
end
