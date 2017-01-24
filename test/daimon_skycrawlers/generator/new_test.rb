require "test_helper"
require "daimon_skycrawlers/generator/new"

class GenerateNewTest < Test::Unit::TestCase
  setup do
    @command = DaimonSkycrawlers::Generator::New
    @current_directory = Dir.pwd
    @working_directory = fixture_path("tmp/new")
    @working_directory.mkpath
    Dir.chdir(@working_directory)
  end

  teardown do
    FileUtils.rm_rf(@working_directory)
    Dir.chdir(@current_directory)
  end

  test "generate new" do
    out = capture_stdout do
      @command.start(["sample"])
    end
    assert_equal(31, out.lines.size)
    source = File.read("sample/README.md")
    assert_equal("# sample\n", source.lines.first)
    db_env = File.read("sample/.env.db").lines.map {|line| line.chomp.split("=") }.to_h
    db_password = db_env.delete("DATABASE_PASSWORD")
    expected_db_env = {
      "POSTGRES_USER" => "postgres",
      "POSTGRES_PASSWORD" => db_password,
      "DATABASE_USER" => "crawler",
      "DATABASE_PREFIX" => "sample"
    }
    assert_equal(expected_db_env, db_env)
    env = File.read("sample/.env").lines.map {|line| line.chomp.split("=") }.to_h
    expected_env = {
      "SKYCRAWLERS_RABBITMQ_HOST" => "sample-rabbitmq",
      "SKYCRAWLERS_RABBITMQ_PORT" => "5672",
      "DATABASE_HOST" => "sample-db",
      "DATABASE_PORT" => "5432",
      "DATABASE_URL" => "postgres://crawler:#{db_password}@sample-db/sample_development"
    }
    assert_equal(expected_env, env)
    docker_compose = YAML.load_file("sample/docker-compose.yml")
    services = docker_compose["services"].keys
    expected_services = ["sample-rabbitmq", "sample-db", "sample-common", "sample-crawler", "sample-processor"]
    assert_equal(expected_services, services)
    expected_migration = <<SOURCE
class CreatePages < ActiveRecord::Migration[5.0]
  def change
    create_table :pages do |t|
      t.string :key
      t.string :url
      t.text :headers
      t.binary :body
      t.datetime :last_modified_at
      t.string :etag

      t.timestamps

      t.index [:key]
      t.index [:key, :updated_at]
      t.index [:url]
      t.index [:url, :updated_at]
    end
  end
end
SOURCE
    Dir.glob("sample/db/migrate/*_create_pages.rb") do |entry|
      assert { File.file?(entry) }
      assert_equal(expected_migration, File.read(entry))
    end
  end
end
