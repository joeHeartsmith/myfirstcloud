#!/bin/bash
# Get AMI Owner (you):  'aws sts get-caller-identity'

echo AWS AMIs
aws ec2 describe-images --filter "Name=owner-id,Values=XXXXXXXXXXXX"
