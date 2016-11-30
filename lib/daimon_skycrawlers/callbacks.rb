module DaimonSkycrawlers
  module Callbacks
    def initialize
      super
      @before_process_callbacks = []
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
  end
end
