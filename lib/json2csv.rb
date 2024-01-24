# frozen_string_literal: true

require "json"
require "csv"


# To separate processing args from code (for tests)
def process_arguments(args)
  if args.length == 2
    json_file_path = args[0]
    csv_file_path = args[1]
    json_to_csv(json_file_path, csv_file_path)
  else
    puts "Usage: ruby lib/json2csv.rb <input_json_file> <output_csv_file>"
    exit(1)
  end
end

# Convert array to comma-delimited string
def convert_list_to_string(val)
  if val.is_a?(Array)
    val.join(",")
  else
    val
  end
end

# Flatten a nested object using dot notation
# hash : Object, ie. user
def flatten_hash(hash, prefix = "")
  hash.each_with_object({}) do |(key, value), flattened_hash|
    new_key = prefix.empty? ? key.to_s : "#{prefix}.#{key}"
    if value.is_a?(Hash)
      flattened_hash.merge!(flatten_hash(value, new_key))
    else
      flattened_hash[new_key] = value
    end
  end
end

# Convert an array of objects with potentially nested structure to a flattened array of objects
# data_array : Array of objects
def flatten_array_of_objects(data_array)
  data_array.map do |row|
    flatten_hash(row).transform_keys(&:to_s).to_h
  end
end

def write_to_csv(csv_file, flat_data)
  CSV.open(csv_file, "w") do |csv|
    csv << flat_data.first.keys

    flat_data.each do |obj|
      converted_row = obj.transform_values { |value| convert_list_to_string(value) }
      csv << converted_row.values
    end
  end
end

# Read JSON input file, flatten nested properties, and write flattened data to CSV output file
def json_to_csv(json_file, csv_file)
  json_data = File.read(json_file)
  data_array = JSON.parse(json_data)
  flattened_data = flatten_array_of_objects(data_array)

  write_to_csv(csv_file, flattened_data)

  puts "Conversion successful! CSV file saved as #{csv_file}"
end

# If this script is run directly from the command line
process_arguments(ARGV) if $PROGRAM_NAME == __FILE__
