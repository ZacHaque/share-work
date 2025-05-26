#!/bin/bash

# Usage check
if [ $# -ne 1 ]; then
  echo "Usage: $0 [upload|delete]"
  exit 1
fi

# Operation mode (upload or delete)
operation="$1"

# Bucket list file and test file
bucket_file="buckets.txt"
test_file="test.txt"
s3_key="test.txt"  # name of the file/key in the bucket

# Check if bucket list file exists
if [ ! -f "$bucket_file" ]; then
  echo "Bucket list file '$bucket_file' not found!"
  exit 1
fi

# Create the test file if uploading
if [ "$operation" == "upload" ]; then
  if [ ! -f "$test_file" ]; then
    echo "Creating test file: $test_file"
    echo "This is a test file." > "$test_file"
  fi
fi

# Iterate through bucket names
while IFS= read -r bucket; do
  # Skip empty lines or comments
  if [[ -z "$bucket" || "$bucket" == \#* ]]; then
    continue
  fi

  case "$operation" in
    upload)
      echo "Uploading $test_file to s3://$bucket/"
      aws s3 cp "$test_file" "s3://$bucket/$s3_key"
      ;;
    delete)
      echo "Deleting s3://$bucket/$s3_key"
      aws s3 rm "s3://$bucket/$s3_key"
      ;;
    *)
      echo "Invalid operation: $operation"
      echo "Use 'upload' or 'delete'"
      exit 1
      ;;
  esac

  echo "Listing contents of s3://$bucket/"
  aws s3 ls "s3://$bucket/"
  echo "----------------------------------"

done < "$bucket_file"
