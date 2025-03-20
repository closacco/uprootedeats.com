#!/bin/bash

# Create the necessary directories
mkdir -p uprooted-static/assets/css

# Copy the main site CSS
cp original-dl-static/static1.squarespace.com/static/sitecss/5d190bc06c11860001978805/45/55f0aac0e4b0f0a5b7e0b22e/5d190bc06c1186000197881b/354/site.css uprooted-static/assets/css/

# Copy all compressed CSS files
cp original-dl-static/assets.squarespace.com/universal/styles-compressed/*.css uprooted-static/assets/css/

echo "CSS files copied successfully!" 