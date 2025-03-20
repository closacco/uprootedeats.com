#!/bin/bash

# Create necessary directories
mkdir -p uprooted-static/assets/js/@sqs/polyfiller/1.6
mkdir -p uprooted-static/assets/js/universal/scripts
mkdir -p uprooted-static/assets/images

# Copy polyfiller files
cp -r original-dl-static/assets.squarespace.com/@sqs/polyfiller/1.6/* uprooted-static/assets/js/@sqs/polyfiller/1.6/

# Copy all JavaScript files from scripts-compressed
cp -r original-dl-static/assets.squarespace.com/universal/scripts-compressed/* uprooted-static/assets/js/universal/scripts/

# Copy all image files from content directory
cp -r original-dl-static/images.squarespace-cdn.com/content/v1/* uprooted-static/assets/images/

# Copy UI icons if they exist
if [ -f "original-dl-static/assets.squarespace.com/universal/ui-icons.svg" ]; then
    cp original-dl-static/assets.squarespace.com/universal/ui-icons.svg uprooted-static/assets/images/
fi

echo "Assets copied successfully!" 