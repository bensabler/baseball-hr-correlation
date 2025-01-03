import os
import chardet
import shutil

def detect_and_convert_encoding(input_path, output_path):
    """
    Detect the encoding of a file and convert it to UTF-8 if necessary.
    """
    try:
        print(f"Processing file: {input_path}")
        with open(input_path, 'rb') as file:
            raw_data = file.read()
            result = chardet.detect(raw_data)
            original_encoding = result['encoding']

        if original_encoding is None:
            print(f"Could not detect encoding for {input_path}")
            return

        if original_encoding.lower() != 'utf-8':
            # Decode with original encoding and encode to UTF-8
            with open(input_path, 'r', encoding=original_encoding) as input_file:
                content = input_file.read()
            with open(output_path, 'w', encoding='utf-8') as output_file:
                output_file.write(content)
            print(f"Converted {input_path} from {original_encoding} to UTF-8")
        else:
            shutil.copyfile(input_path, output_path)
            print(f"{input_path} is already in UTF-8")
    except Exception as e:
        print(f"Error processing {input_path}: {e}")

if __name__ == "__main__":
    raw_data_directory = '../../data/raw'
    encoded_data_directory = '../../data/encoded'

    if not os.path.exists(encoded_data_directory):
        os.makedirs(encoded_data_directory)

    for filename in os.listdir(raw_data_directory):
        if filename.endswith('.csv'):
            input_file = os.path.join(raw_data_directory, filename)
            output_file = os.path.join(encoded_data_directory, f"{os.path.splitext(filename)[0]}.csv")
            detect_and_convert_encoding(input_file, output_file)
            print(f"Finished processing file: {input_file}\n")