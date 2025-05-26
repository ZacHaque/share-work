#!/bin/bash

# List of bucket names
buckets=("bucket-name-1" "bucket-name-2" "bucket-name-3")

# Path to the test file
test_file="test.txt"

# Check if test file exists
if [ ! -f "$test_file" ]; then
  echo "Creating test file: $test_file"
  echo "This is a test file." > "$test_file"
fi

# Iterate through the bucket list
for bucket in "${buckets[@]}"; do
  echo "Uploading $test_file to s3://$bucket/"
  aws s3 cp "$test_file" "s3://$bucket/"

  echo "Listing contents of s3://$bucket/"
  aws s3 ls "s3://$bucket/"
  echo "----------------------------------"
done
