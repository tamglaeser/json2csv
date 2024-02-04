# JSON2CSV

This project implements a small Ruby library that converts JSON files composed of arrays of objects (all following the 
same schema) to CSV files where one line equals one object.

## Getting Started

### Installation

1. Clone the repository:

    ```bash
    git clone git@github.com:tamglaeser/json2csv.git
    ```

2. Navigate to the project directory:

    ```bash
    cd json2csv
    ```

3. Install dependencies:

    ```bash
    bundle install
    ```

### Usage

To use the library:

```bash
ruby lib/json2csv.rb <input_json_file> <output_csv_file>
```

To test the library:
```bash
ruby test/json2csv_test.rb
```

To run lint on the library (code quality):
```bash
rubocop
```

### Project Structure
````bash
json2csv/
│
├── data/        # Contains sample json/csv files
│
├── lib/         # Library logic, ie. json2csv.rb
│
├── test/        # Contains unit tests
│
├── Gemfile/     # Contains dependencies
└── ...          # Other project-related files and folders

````

### Future Work

#### Big(O)

##### Time Complexity
The time complexity for the current code is O(n \* m) where n is the number of objects within the input JSON array and m 
is the number of key-value pairs within each object. This is because the principle tasks of this library are (1) 
flattening each object within the input JSON to define nested objects using dot-notation and (2) writing this flattened 
data to the output CSV file, both of which have complexity O(n \* m) and so O(n \* m) + O(n \* m) = O(2(n \* m)) = 
O(n \* m). This calculation assumes that the size of the JSON data when reading/parsing it and the new number of keys 
within the flattened objects are not significant compared to the 2 dominant factors, n and m.

##### Space Complexity
The space complexity is also O(n \* m).