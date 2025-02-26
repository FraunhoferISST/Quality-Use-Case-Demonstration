import json
import uuid
import re

def generate_new_uuids(json_data):
    # Create a dictionary to map old UUIDs to new UUIDs
    uuid_map = {}

    # Function to replace UUIDs recursively
    def replace_uuids(data):
        if isinstance(data, dict):
            for key, value in data.items():
                if isinstance(value, str):
                    # Check if the value is a UUID
                    if re.match(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$', value):
                        # Generate a new UUID if this is the first time we've seen this UUID
                        if value not in uuid_map:
                            uuid_map[value] = str(uuid.uuid4())
                        # Replace the old UUID with the new UUID
                        data[key] = uuid_map[value]
                else:
                    replace_uuids(value)
        elif isinstance(data, list):
            for item in data:
                replace_uuids(item)

    # Replace all UUIDs in the JSON data
    replace_uuids(json_data)

    return json_data

def main():
    # Load your JSON data
    filename = 'Customer-realm2.json'
    with open(filename, 'r') as file:
        json_data = json.load(file)

    # Replace UUIDs
    updated_json_data = generate_new_uuids(json_data)

    # Save the updated JSON data
    with open('updated_' + filename, 'w') as file:
        json.dump(updated_json_data, file, indent=4)

    print("Updated JSON file has been saved as 'updated_" + filename + "'")

if __name__ == "__main__":
    main()
