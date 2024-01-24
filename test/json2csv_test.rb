require_relative "../lib/json2csv"
require "test/unit"
require "stringio"

class TestJson2Csv < Test::Unit::TestCase
  def setup
    # Set the working directory to the location of the test file
    Dir.chdir(File.expand_path("..", __dir__))
  end

  def teardown
    # Clean up by deleting the output.csv file
    output_csv_path = File.expand_path("../data/output.csv", __dir__)
    File.delete(output_csv_path) if File.exist?(output_csv_path)
  end

  # Test args
  def test_json_to_csv_with_valid_arguments
    # Provide the paths to your test JSON file and output CSV file
    input_json_path = File.expand_path("../data/users.json", __dir__)
    output_csv_path = File.expand_path("../data/output.csv", __dir__)

    # Capture stdout and stderr
    _stdout, _stderr = capture_output do
      process_arguments([input_json_path, output_csv_path])
    end

    # Check if the CSV file is created or other expected output
    assert(File.exist?(output_csv_path), "CSV file should be created")
  end

  def test_json_to_csv_with_invalid_arguments
    expected_message = "Usage: ruby lib/json2csv.rb <input_json_file> <output_csv_file>"

    # Redirect stdout and stderr to StringIO objects
    original_stdout = $stdout
    original_stderr = $stderr
    $stdout = StringIO.new
    $stderr = StringIO.new

    begin
      process_arguments([])
      actual_stderr = $stderr.string

      assert_match(/#{Regexp.escape(expected_message)}/, actual_stderr)
    ensure
      # Restore original stdout and stderr
      $stdout = original_stdout
      $stderr = original_stderr
    end
  end

  # Test convert_list_to_string
  def test_convert_list_to_string_with_array
    # Test when val is an array
    val = ["apple", "banana", "orange"]
    result = convert_list_to_string(val)
    assert_equal("apple,banana,orange", result)
  end

  def test_convert_list_to_string_with_non_array
    # Test when val is not an array
    val = "apple"
    result = convert_list_to_string(val)
    assert_equal("apple", result)
  end

  def test_convert_list_to_string_with_empty_array
    # Test when val is an empty array
    val = []
    result = convert_list_to_string(val)
    assert_equal("", result)
  end

  def test_convert_list_to_string_with_nil
    # Test when val is nil
    val = nil
    result = convert_list_to_string(val)
    assert_nil(result)
  end

  # Test flatten_hash
  def test_flatten_hash
    nested_hash = { "key1" => { "key2" => "value" }, "key3" => "another_value" }
    flattened_hash = flatten_hash(nested_hash)

    expected_hash = { "key1.key2" => "value", "key3" => "another_value" }

    assert_equal(expected_hash, flattened_hash)
  end

  def test_flatten_array_of_objects
    a = [{ "key1" => { "key2" => "value" }, "key3" => "another_value" }, { "foo" => { "bar" => "baz" } }]
    flattened_array = flatten_array_of_objects(a)

    expected_array = [{ "key1.key2" => "value", "key3" => "another_value" }, { "foo.bar" => "baz" }]

    assert_equal(expected_array, flattened_array)
  end

  def test_json_to_csv
    input_json_path = File.expand_path("../data/users.json", __dir__)
    expected_csv_path = File.expand_path("../data/users.csv", __dir__)
    output_csv_path = File.expand_path("../data/output.csv", __dir__)

    process_arguments([input_json_path, output_csv_path])

    # Check if the generated CSV matches the expected CSV
    assert_equal(File.read(expected_csv_path), File.read(output_csv_path))
  end
end
