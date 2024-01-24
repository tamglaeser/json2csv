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