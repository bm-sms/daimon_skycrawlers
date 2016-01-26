require 'fileutils'
require 'stringio'
require 'tempfile'
require 'timeout'

Given /^I have the "([^"]*)" application$/ do |path|
  @current_app_path = fixture_path(path)
end

When /^I run crawler & processor$/ do
  @worker_pids = []
  dir = Dir.tmpdir
  @processor_out_path = "#{dir}/processor.log"
  @crawler_out_path = "#{dir}/crawler_out.log"

  Bundler.with_clean_env {
    @worker_pids << spawn("bundle exec ruby #{@current_app_path.join('crawler.rb')}", out: @crawler_out_path, err: @crawler_out_path)
    @worker_pids << spawn("bundle exec ruby #{@current_app_path.join('processor.rb')}", out: @processor_out_path, err: @processor_out_path)
  }
end

Then /^processor receives the following message:$/ do |message|
  data = nil

  begin
    Timeout.timeout(5) do
      # XXX dirty way...
      while true
        data = File.read(@processor_out_path)
        raise Timeout::Error if Regexp.compile(Regexp.escape(message)) =~ data
        sleep 0.2
      end
    end
  rescue Timeout::Error
    # noop
  ensure
    assert_match message, data
  end
end

After do |scenario|
  @worker_pids.each do |pid|
    Process.kill 'INT', pid
  end
end
