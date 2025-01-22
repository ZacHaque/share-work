# share-work


To restrict access to an Amazon S3 bucket so that only a specific IAM role can perform read, write, and list operations, you need to create a bucket policy that grants access to that role. Additionally, the IAM role itself needs to have permissions to interact with S3.

1. Bucket Policy
Here’s an example of an S3 bucket policy that allows access only to a specific IAM role:

json
Copy
Edit
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::123456789012:role/YourSpecificRoleName"
      },
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::your-bucket-name",
        "arn:aws:s3:::your-bucket-name/*"
      ]
    }
  ]
}
Replace the following placeholders:

123456789012: Your AWS account ID.
YourSpecificRoleName: The name of the IAM role you want to grant access.
your-bucket-name: The name of your S3 bucket.
2. IAM Role Policy
The IAM role must have a policy attached to it that allows it to access the bucket. Here’s an example of an IAM policy to attach to the role:

json
Copy
Edit
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::your-bucket-name",
        "arn:aws:s3:::your-bucket-name/*"
      ]
    }
  ]
}
Steps to Implement:
Create or Update the Bucket Policy:

Navigate to the S3 console.
Open the bucket's Permissions tab.
Edit the Bucket Policy section with the policy above.
Attach the IAM Policy to the Role:

Go to the IAM console.
Find the role you want to use.
Attach the IAM policy to the role using the policy above.
Test the Access:

Use the IAM role to access the bucket and ensure that only the specified operations are allowed.
By combining the bucket policy and IAM role policy, you ensure that only the specified role from your account can access the bucket with the specified permissions.
