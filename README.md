# How to do bucket permission on AWS

This doc to cover creating a AWS bucket and only allow specific user on same account tot access it


# Create bucket

1. Create bucket with below policy eg `testing-bucket-198237187239`
2. Update with policy like below 
```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::123456789123:role/test-bucket-iam-role"
      },
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::testing-bucket-198237187239",
        "arn:aws:s3:::testing-bucket-198237187239/*"
      ]
    }
  ]
}
```

## Create a IAM policy

1. Create a IAM policy to access the bucket
```
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
        "arn:aws:s3:::testing-bucket-198237187239",
        "arn:aws:s3:::testing-bucket-198237187239/*"
      ]
    }
  ]
}
```

## Create a IAM role

1. Create a AWS IAM role eg `test-bucket-iam-role`
2. Attach the policy create above to this role
3. To enhance security who can assume this role attach a trust policy like below
```
# Trust policy so only bob can assume this role, no one else
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::123456789012:user/bob"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

## Create bob the user

1.  Create a AWS IAM user eg `bob`
2. Create AWS cli access for , note down the AWS access key and secret access key
3. Add following assume role policy so Bob can assume the IAM role created before
```
# Assume role policy for bob the user
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "arn:aws:iam::123456789123:role/test-bucket-iam-role"
        }
    ]
}
```
## Test the access

1. Set up the AWS cli access with env
```
export AWS_ACCESS_KEY_ID=XXXXXXXXXXX
export AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```
2.  Anytime can check who accessing AWS `aws sts get-caller-identity ` should show bob access
3. Now make bob to assume the role
```
aws sts assume-role \
    --role-arn "arn:aws:iam::123456789123:role/test-bucket-iam-role" \
    --role-session-name "AccessTestBucket"

```
5. Fill below from output of above command
```
export AWS_ACCESS_KEY_ID=XXXXXXXXXXX
export AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
export AWS_SESSION_TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXxWRBajZ9yraUNQMsFfIjXXXXXXXXXXXXX
```
6. check who accessing AWS `aws sts get-caller-identity ` should show bob now assuming role
7. Run AWS s3 command to verify `aws s3 ls s3://testing-bucket-198237187239/`



## More info
https://repost.aws/knowledge-center/iam-assume-role-cli
