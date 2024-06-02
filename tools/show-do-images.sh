#!/bin/bash
echo DigitalOcean Images
doctl compute image list | grep site | awk '{print $2;}'
