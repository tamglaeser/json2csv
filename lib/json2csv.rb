# frozen_string_literal: true
require 'json'
require 'csv'


# Convert array to comma-delimited string
def convert_list_to_string(val)
  if val.is_a?(Array)
    val.join(',')
  else
    val
  end
end

# Flatten a nested object using dot notation
# hash : Object, ie. user
def flatten_hash(hash, prefix = '')
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
    Hash[flatten_hash(row).map { |k, v| [k.to_s, v] }]
  end
end


# Read JSON input file, flatten nested properties, and write flattened data to CSV output file
def json_to_csv(json_file, csv_file)
  json_data = File.read(json_file)
  data_array = JSON.parse(json_data)

  flattened_data = flatten_array_of_objects(data_array)

  CSV.open(csv_file, 'w') do |csv|
    csv << flattened_data.first.keys

    flattened_data.each do |obj|
      #csv << obj.values
      converted_row = obj.transform_values { |value| convert_list_to_string(value) }
      csv << converted_row.values
    end
  end

  puts "Conversion successful! CSV file saved as #{csv_file}"
end

if ARGV.length != 2
  puts "Usage: ruby json2csv.rb <input_json_file> <output_csv_file>"
  exit(1)
end

json_file_path = ARGV[0]
csv_file_path = ARGV[1]

json_to_csv(json_file_path, csv_file_path)