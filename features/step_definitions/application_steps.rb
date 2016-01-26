require 'fileutils'
require 'stringio'
require 'tempfile'
require 'timeout'

Given /^I have the "([^"]*)" application$/ do |path|
  @current_app_path = fixture_path(path)

  Bundler.with_clean_env do
    Dir.chdir(@current_app_path) do
      `rm -rf db/*.sqlite3`
      `bundle exec rake db:migrate`
    end
  end
end

When /^I run crawler & processor$/ do
  @worker_pids = []
  dir = Dir.tmpdir
  @processor_log_path = "#{dir}/processor.log"
  @crawler_log_path = "#{dir}/crawler.log"

  Bundler.with_clean_env do
    Dir.chdir(@current_app_path) do
      @worker_pids << spawn("bundle exec ruby #{@current_app_path.join('processor.rb')}", out: @processor_log_path, err: @processor_log_path)
      @worker_pids << spawn("bundle exec ruby #{@current_app_path.join('crawler.rb')}", out: @crawler_log_path, err: @crawler_log_path)
    end
  end
end

Then /^processor receives the following message:$/ do |message|
  data = nil

  begin
    Timeout.timeout(5) do
      # XXX dirty way...
      while true
        data = File.read(@processor_log_path)
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
    Process.kill 'SIGINT', pid
  end
end
