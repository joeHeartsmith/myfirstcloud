#!/bin/bash
# Get AMI Owner (you):  'aws sts get-caller-identity'
for image in $(aws ec2 describe-images --filter "Name=owner-id,Values=XXXXXXXXXXXX" | jq '.Images[].ImageId' | tr -d '"'); do aws ec2 deregister-image --image-id $image; done
