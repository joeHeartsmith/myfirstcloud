#!/bin/bash
for image in $(doctl compute image list | grep site | awk '{print $1;}'); do doctl compute image delete $image -f; done
