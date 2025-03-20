#!/bin/bash

# Update CSS references
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|../static1.squarespace.com/static/sitecss/|assets/css/|g' {} +
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|assets/js/universal/styles-compressed/|assets/css/|g' {} +

# Update JavaScript references
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|../assets.squarespace.com/|assets/js/|g' {} +
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|//assets.squarespace.com/|assets/js/|g' {} +
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|@sqs/polyfiller/|assets/js/@sqs/polyfiller/|g' {} +
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|assets/js/assets/js/|assets/js/|g' {} +
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|/assets/js/assets/js/|/assets/js/|g' {} +
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|assets/js/assets/js/assets/js/|assets/js/|g' {} +
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|assets/js/assets/js/@sqs/|assets/js/@sqs/|g' {} +

# Fix JavaScript paths in SQUARESPACE_ROLLUPS
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|rollups\[name\].js = \[assets/js/|rollups[name].js = ["assets/js/|g' {} +

# Fix CSS paths in SQUARESPACE_ROLLUPS
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|rollups\[name\].css = \[assets/css/|rollups[name].css = ["assets/css/|g' {} +

# Fix Static object initialization and image paths
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|Static = window.Static \|\| {};|window.Static = window.Static \|\| {};|g' {} +
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|"logoImageUrl":assets/images/|"logoImageUrl":"assets/images/|g' {} +
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|<script>Static.COOKIE_BANNER_CAPABLE|<script>window.Static = window.Static \|\| {}; Static.COOKIE_BANNER_CAPABLE|g' {} +

# Fix social media URLs
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|"profileUrl":"http:/|"profileUrl":"https://|g' {} +

# Update image references
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|../images.squarespace-cdn.com/|assets/images/|g' {} +
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|//images.squarespace-cdn.com/|assets/images/|g' {} +
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|assets/images/content/v1/[^/]*/[^/]*/|assets/images/|g' {} +
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|assets/images/content/5d190bc06c11860001978805/[^/]*/|assets/images/|g' {} +

# Remove all format parameters from image paths
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|?format=[0-9]*w\.jpg|.jpg|g' {} +
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|?format=[0-9]*w\.jpeg|.jpeg|g' {} +
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|?format=[0-9]*w\.png|.png|g' {} +
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|&content-type=image%EA%A4%B7png\.png|.png|g' {} +
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|&content-type=image%EA%A4%B7jpeg\.jpeg|.jpeg|g' {} +
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|&content-type=image%EA%A4%B7jpg\.jpg|.jpg|g' {} +

# Fix logo image paths
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|Uprooted\+Beet\+logo\?format=1500w\&content-type=image%EA%A4%B7png\.png|Uprooted+Beet+logo.png|g' {} +

# Fix UI icon paths
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|/assets/images/ui-icons\.svg|assets/images/ui-icons.svg|g' {} +

# Update any remaining Squarespace-specific references
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|https://tangerine-pomegranate-85y3.squarespace.com|/|g' {} +

# Fix any double slashes in paths
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|//|/|g' {} +

# Fix any remaining protocol-relative URLs
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|//assets|/assets|g' {} +
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|//images|/images|g' {} +

# Fix Google Fonts URL encoding and update to direct Google URLs
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|%EF%B9%96|?|g' {} +
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|%EF%B9%95|,|g' {} +
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|%EF%B9%94|:|g' {} +

# Fix image format parameters
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|%EF%B9%96format=|?format=|g' {} +

# Update Google Fonts URLs to load directly from Google
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|fonts.googleapis.com/css2.*family=Rubik.*css|https://fonts.googleapis.com/css2?family=Rubik:ital,wght@0,300;0,400;0,500;0,700;1,300;1,400;1,700\&display=swap|g' {} +
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|../https:/fonts.googleapis.com|https://fonts.googleapis.com|g' {} +
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|../https://fonts.googleapis.com|https://fonts.googleapis.com|g' {} +
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|https:/fonts.googleapis.com|https://fonts.googleapis.com|g' {} +
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|https:/fonts.gstatic.com|https://fonts.gstatic.com|g' {} +

# Fix favicon path
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|assets/js/universal/default-favicon.ico|assets/images/favicon.ico|g' {} +

# Fix UI icons path
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|/assets/ui-icons.svg|/assets/images/ui-icons.svg|g' {} +

# Fix unquoted paths in SQUARESPACE_CONTEXT
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|"js":assets/js/|"js":"assets/js/|g' {} +
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|"css":assets/css/|"css":"assets/css/|g' {} +
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|"logoImageUrl":assets/images/|"logoImageUrl":"assets/images/|g' {} +

# Fix templateScriptsRootUrl path
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|"templateScriptsRootUrl":"https:/static1.squarespace.com/static/ta/55f0a9b0e4b0f3eb70352f6d/354/scripts/"|"templateScriptsRootUrl":"/assets/js/"|g' {} +

# Fix site-bundle.js path
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|../static1.squarespace.com/static/ta/55f0a9b0e4b0f3eb70352f6d/354/scripts/site-bundle.js|/assets/js/site-bundle.js|g' {} +

# Fix single slashes in https URLs (only when there's exactly one slash)
find uprooted-static -name "*.html" -type f -exec sed -i '' 's|https:/\([^/]\)|https://\1|g' {} +

echo "References updated successfully!"