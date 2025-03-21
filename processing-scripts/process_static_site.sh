#!/bin/bash

# Check if source and destination directories are provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <source_directory> <destination_directory>"
    exit 1
fi

SOURCE_DIR="$1"
DEST_DIR="$2"

# Create necessary directories
mkdir -p "${DEST_DIR}/assets/js"
mkdir -p "${DEST_DIR}/assets/css"
mkdir -p "${DEST_DIR}/assets/images"
mkdir -p "${DEST_DIR}/assets/js/@sqs/polyfiller/1.6"
mkdir -p "${DEST_DIR}/assets/css/5d190bc06c11860001978805/45/55f0aac0e4b0f0a5b7e0b22e/5d190bc06c1186000197881b/354"

# Copy modern.js with directory structure
echo "Copying modern.js..."
cp "${SOURCE_DIR}/assets.squarespace.com/@sqs/polyfiller/1.6/modern.js" "${DEST_DIR}/assets/js/@sqs/polyfiller/1.6/modern.js"

# Copy site.css with directory structure
echo "Copying site.css..."
cp "${SOURCE_DIR}/static1.squarespace.com/static/sitecss/5d190bc06c11860001978805/45/55f0aac0e4b0f0a5b7e0b22e/5d190bc06c1186000197881b/354/site.css" "${DEST_DIR}/assets/css/5d190bc06c11860001978805/45/55f0aac0e4b0f0a5b7e0b22e/5d190bc06c1186000197881b/354/site.css"

# Copy site-bundle.js with directory structure
echo "Copying site-bundle.js..."
cp "${SOURCE_DIR}/static1.squarespace.com/static/ta/55f0a9b0e4b0f3eb70352f6d/354/scripts/site-bundle.js" "${DEST_DIR}/assets/js/site-bundle.js"

# Copy HTML files maintaining directory structure
echo "Copying HTML files..."
find "${SOURCE_DIR}/tangerine-pomegranate-85y3.squarespace.com" -name "*.html" -type f -exec bash -c '
    SOURCE_DIR="$1"
    DEST_DIR="$2"
    file="$3"
    # Get the relative path from the squarespace directory
    rel_path="${file#${SOURCE_DIR}/tangerine-pomegranate-85y3.squarespace.com/}"
    # Create the destination directory
    mkdir -p "${DEST_DIR}/$(dirname "$rel_path")"
    # Copy the file
    cp "$file" "${DEST_DIR}/$rel_path"
' bash "${SOURCE_DIR}" "${DEST_DIR}" {} \;

# Copy JavaScript files
echo "Copying JavaScript files..."
find "${SOURCE_DIR}/assets.squarespace.com" -type f \( -name "*.js" -o -name "*.js.gz" \) -exec bash -c '
    DEST_DIR="$1"
    file="$2"
    # Get just the filename
    filename=$(basename "$file")
    # Copy to assets/js
    cp "$file" "${DEST_DIR}/assets/js/$filename"
' bash "${DEST_DIR}" {} \;

# Copy CSS files from multiple locations
echo "Copying CSS files..."
# Copy from static1.squarespace.com (deep directory structure)
find "${SOURCE_DIR}/static1.squarespace.com" -type f -name "site.css" -exec bash -c '
    DEST_DIR="$1"
    file="$2"
    # Get just the filename
    filename=$(basename "$file")
    # Copy to assets/css
    cp "$file" "${DEST_DIR}/assets/css/$filename"
' bash "${DEST_DIR}" {} \;

# Copy from assets.squarespace.com/universal/styles-compressed
find "${SOURCE_DIR}/assets.squarespace.com/universal/styles-compressed" -type f \( -name "*.css" -o -name "*.css.gz" \) -exec bash -c '
    DEST_DIR="$1"
    file="$2"
    # Get just the filename
    filename=$(basename "$file")
    # Copy to assets/css
    cp "$file" "${DEST_DIR}/assets/css/$filename"
' bash "${DEST_DIR}" {} \;

# Copy from static1.squarespace.com/static/ta (template assets)
find "${SOURCE_DIR}/static1.squarespace.com/static/ta" -type f -name "*.css" -exec bash -c '
    DEST_DIR="$1"
    file="$2"
    # Get just the filename
    filename=$(basename "$file")
    # Copy to assets/css
    cp "$file" "${DEST_DIR}/assets/css/$filename"
' bash "${DEST_DIR}" {} \;

# Copy all component CSS files
for dir in "${SOURCE_DIR}/assets.squarespace.com/universal/styles-compressed" "${SOURCE_DIR}/assets.squarespace.com/universal/styles-compressed/components"; do
    if [ -d "$dir" ]; then
        find "$dir" -type f -name "*.css" -exec bash -c '
            DEST_DIR="$1"
            file="$2"
            # Get just the filename
            filename=$(basename "$file")
            # Copy to assets/css
            cp "$file" "${DEST_DIR}/assets/css/$filename"
        ' bash "${DEST_DIR}" {} \;
    fi
done

# Download missing CSS files
echo "Downloading missing CSS files..."
# Create a temporary file to store URLs
TEMP_FILE=$(mktemp)

# Extract CSS URLs from HTML files
find "${SOURCE_DIR}" -name "*.html" -type f -exec grep -o "//assets.squarespace.com/universal/styles-compressed/[^\"]*\.css" {} \; | sort -u > "$TEMP_FILE"

# Download each CSS file
while IFS= read -r url; do
    # Remove leading //
    url="https:${url}"
    # Get just the filename
    filename=$(basename "$url")
    # Download the file if it doesn't exist
    if [ ! -f "${DEST_DIR}/assets/css/$filename" ]; then
        echo "Downloading $url..."
        curl -s "$url" -o "${DEST_DIR}/assets/css/$filename"
    fi
done < "$TEMP_FILE"

# Clean up
rm "$TEMP_FILE"

# Copy image files
echo "Copying image files..."
find "${SOURCE_DIR}/images.squarespace-cdn.com" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" -o -name "*.svg" -o -name "*.ico" -o -name "*.JPG" \) | while read -r file; do
    # Get just the filename
    filename=$(basename "$file")
    # Remove format parameters and special characters
    clean_filename=$(echo "$filename" | sed 's/?format=[0-9]*w//g' | sed 's/&content-type=image%EA%A4%B7[^.]*//g' | sed 's/﹖format=[0-9]*w//g' | sed 's/﹖content-type=image%EA%A4%B7[^.]*//g')
    # Copy to assets/images if it doesn't already exist
    if [[ ! -f "${DEST_DIR}/assets/images/$clean_filename" ]]; then
        echo "Copying $clean_filename..."
        cp "$file" "${DEST_DIR}/assets/images/$clean_filename"
    fi
done

# Copy JavaScript files from multiple locations
echo "Copying JavaScript files..."
# Copy from assets.squarespace.com
find "${SOURCE_DIR}/assets.squarespace.com" -type f \( -name "*.js" -o -name "*.js.gz" \) -exec bash -c '
    DEST_DIR="$1"
    file="$2"
    # Get just the filename
    filename=$(basename "$file")
    # Copy to assets/js
    cp "$file" "${DEST_DIR}/assets/js/$filename"
' bash "${DEST_DIR}" {} \;

# Copy from static1.squarespace.com/static/ta
find "${SOURCE_DIR}/static1.squarespace.com/static/ta" -type f -name "*.js" -exec bash -c '
    DEST_DIR="$1"
    file="$2"
    # Get just the filename
    filename=$(basename "$file")
    # Copy to assets/js
    cp "$file" "${DEST_DIR}/assets/js/$filename"
' bash "${DEST_DIR}" {} \;

# Download missing JavaScript files
echo "Downloading missing JavaScript files..."
# Create a temporary file to store URLs
TEMP_FILE=$(mktemp)

# Extract JavaScript URLs from HTML files
find "${SOURCE_DIR}" -name "*.html" -type f -exec grep -o "//assets.squarespace.com/[^\"]*\.js" {} \; | sort -u > "$TEMP_FILE"

# Download each JavaScript file
while IFS= read -r url; do
    # Remove leading //
    url="https:${url}"
    # Get just the filename
    filename=$(basename "$url")
    # Download the file if it doesn't exist
    if [ ! -f "${DEST_DIR}/assets/js/$filename" ]; then
        echo "Downloading $url..."
        curl -s "$url" -o "${DEST_DIR}/assets/js/$filename"
    fi
done < "$TEMP_FILE"

# Clean up
rm "$TEMP_FILE"

# Update references in HTML files
echo "Updating references in HTML files..."

# Update CSS references
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|../static1.squarespace.com/static/sitecss/|assets/css/|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|assets/js/universal/styles-compressed/|assets/css/|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|//assets.squarespace.com/universal/styles-compressed/|assets/css/|g' {} +

# Update JavaScript references
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|../assets.squarespace.com/|assets/js/|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|//assets.squarespace.com/|assets/js/|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|@sqs/polyfiller/|assets/js/@sqs/polyfiller/|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|assets/js/assets/js/|assets/js/|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|/assets/js/assets/js/|/assets/js/|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|assets/js/assets/js/assets/js/|assets/js/|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|assets/js/assets/js/@sqs/|assets/js/@sqs/|g' {} +

# Fix JavaScript paths in SQUARESPACE_ROLLUPS
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|rollups\[name\].js = \[assets/js/|rollups[name].js = ["assets/js/|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|"js":\[assets/js/|"js":["assets/js/|g' {} +

# Fix CSS paths in SQUARESPACE_ROLLUPS
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|rollups\[name\].css = \[assets/css/|rollups[name].css = ["assets/css/|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|"css":\[assets/css/|"css":["assets/css/|g' {} +

# Fix CSS paths in link tags
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|href="assets/js/universal/styles-compressed/|href="assets/css/|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|href="assets/js/universal/styles-compressed/|href="assets/css/|g' {} +

# Fix JavaScript paths in script tags
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|src="assets/js/universal/scripts-compressed/|src="assets/js/|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|src="assets/js/@sqs/polyfiller/|src="assets/js/@sqs/polyfiller/|g' {} +

# Fix paths in SQUARESPACE_CONTEXT
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|"js":"assets/js/universal/scripts-compressed/|"js":"assets/js/|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|"css":"assets/js/universal/styles-compressed/|"css":"assets/css/|g' {} +

# Fix templateScriptsRootUrl path
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|"templateScriptsRootUrl":"https:/static1.squarespace.com/static/ta/55f0a9b0e4b0f3eb70352f6d/354/scripts/"|"templateScriptsRootUrl":"/assets/js/"|g' {} +

# Fix site-bundle.js path
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|../static1.squarespace.com/static/ta/55f0a9b0e4b0f3eb70352f6d/354/scripts/site-bundle.js|assets/js/site-bundle.js|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|src="/assets/js/site-bundle.js"|src="assets/js/site-bundle.js"|g' {} +

# Fix single slashes in https URLs (only when there's exactly one slash)
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|https:/\([^/]\)|https://\1|g' {} +

# Fix Static object initialization and image paths
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|Static = window.Static \|\| {};|window.Static = window.Static \|\| {};|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|"logoImageUrl":assets/images/|"logoImageUrl":"assets/images/|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|<script>Static.COOKIE_BANNER_CAPABLE|<script>window.Static = window.Static \|\| {}; Static.COOKIE_BANNER_CAPABLE|g' {} +

# Fix social media URLs
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|"profileUrl":"http:/|"profileUrl":"https://|g' {} +

# Update image references to prevent format parameter appending
echo "Updating image references to prevent format parameter appending..."
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|data-src="assets/images/\([^"]*\)?format=[^"]*"|data-src="assets/images/\1"|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|data-image="assets/images/\([^"]*\)?format=[^"]*"|data-image="assets/images/\1"|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|src="assets/images/\([^"]*\)?format=[^"]*"|src="assets/images/\1"|g' {} +

# Remove srcset attributes entirely to prevent responsive image loading
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|srcset="[^"]*"||g' {} +

# Update SQUARESPACE_CONTEXT to prevent format parameter appending
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|"image":"assets/images/\([^"]*\)?format=[^"]*"|"image":"assets/images/\1"|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|"logoImageUrl":"assets/images/\([^"]*\)?format=[^"]*"|"logoImageUrl":"assets/images/\1"|g' {} +

# Fix remaining image paths
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|../images.squarespace-cdn.com/content/v1/[^/]*/[^/]*/|assets/images/|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|//images.squarespace-cdn.com/content/v1/[^/]*/[^/]*/|assets/images/|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|assets/images/content/v1/[^/]*/[^/]*/|assets/images/|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|assets/images/content/5d190bc06c11860001978805/[^/]*/|assets/images/|g' {} +

# Fix UI icon paths
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|/assets/images/ui-icons\.svg|assets/images/ui-icons.svg|g' {} +

# Fix remaining format parameters in image paths
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|?format=[0-9]*w\.jpg|.jpg|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|?format=[0-9]*w\.jpeg|.jpeg|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|?format=[0-9]*w\.png|.png|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|&content-type=image%EA%A4%B7png\.png|.png|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|&content-type=image%EA%A4%B7jpeg\.jpeg|.jpeg|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|&content-type=image%EA%A4%B7jpg\.jpg|.jpg|g' {} +

# Fix logo image paths
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|Uprooted\+Beet\+logo\?format=1500w\&content-type=image%EA%A4%B7png\.png|Uprooted+Beet+logo.png|g' {} +

# Update any remaining Squarespace-specific references
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|https://tangerine-pomegranate-85y3.squarespace.com|/|g' {} +

# Fix any double slashes in paths
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|//|/|g' {} +

# Fix any remaining protocol-relative URLs
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|//assets|/assets|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|//images|/images|g' {} +

# Fix Google Fonts URL encoding and update to direct Google URLs
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|%EF%B9%96|?|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|%EF%B9%95|,|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|%EF%B9%94|:|g' {} +

# Fix image format parameters
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|%EF%B9%96format=|?format=|g' {} +

# Update Google Fonts URLs to load directly from Google
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|fonts.googleapis.com/css2.*family=Rubik.*css|https://fonts.googleapis.com/css2?family=Rubik:ital,wght@0,300;0,400;0,500;0,700;1,300;1,400;1,700\&display=swap|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|../https:/fonts.googleapis.com|https://fonts.googleapis.com|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|../https://fonts.googleapis.com|https://fonts.googleapis.com|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|https:/fonts.googleapis.com|https://fonts.googleapis.com|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|https:/fonts.gstatic.com|https://fonts.gstatic.com|g' {} +

# Fix favicon path
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|assets/js/universal/default-favicon.ico|assets/images/favicon.ico|g' {} +

# Fix UI icons path
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|/assets/ui-icons.svg|/assets/images/ui-icons.svg|g' {} +

# Fix unquoted paths in SQUARESPACE_CONTEXT
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|"js":assets/js/|"js":"assets/js/|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|"css":assets/css/|"css":"assets/css/|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|"logoImageUrl":assets/images/|"logoImageUrl":"assets/images/|g' {} +

# Fix image paths in SQUARESPACE_CONTEXT
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|"image":assets/images/|"image":"assets/images/|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|"image":"assets/images/[^"]*?format=[^"]*"|"image":"assets/images/Uprooted+Beet+logo.png"|g' {} +

# Fix remaining universal/scripts-compressed references
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|assets/js/universal/scripts-compressed/|assets/js/|g' {} +

# Fix remaining universal/styles-compressed references
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|assets/css/universal/styles-compressed/|assets/css/|g' {} +

# Fix remaining format parameters in image paths
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|?format=[0-9]*w&amp;content-type=image%EA%A4%B7[^"]*"|.png"|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|?format=[0-9]*w&amp;content-type=image%EA%A4%B7[^"]*"|.jpg"|g' {} +

# Fix remaining protocol-relative URLs
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|http:/\([^/]\)|http://\1|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|https:/\([^/]\)|https://\1|g' {} +

# Fix remaining image paths with format parameters
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|?format=[0-9]*w"|.png"|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|?format=[0-9]*w"|.jpg"|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|?format=[0-9]*w&amp;|.png|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|?format=[0-9]*w&amp;|.jpg|g' {} +

# Fix remaining JavaScript paths
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|"js":\["assets/js/universal/scripts-compressed/|"js":["assets/js/|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|"js":\[assets/js/|"js":["assets/js/|g' {} +

# Fix remaining CSS paths
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|"css":\["assets/css/universal/styles-compressed/|"css":["assets/css/|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|"css":\[assets/css/|"css":["assets/css/|g' {} +

# Fix remaining image paths
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|"image":"assets/images/[^"]*?format=[^"]*"|"image":"assets/images/Uprooted+Beet+logo.png"|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|"logoImageUrl":"assets/images/[^"]*?format=[^"]*"|"logoImageUrl":"assets/images/Uprooted+Beet+logo.png"|g' {} +

# Fix SVG icon paths
echo "Fixing SVG icon paths..."
find "${DEST_DIR}" -type f -name "*.html" -exec sed -i '' 's|xlink:href="/assets/|xlink:href="assets/|g' {} \;

# Fix protocol-relative URLs
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|//assets|/assets|g' {} +
find "${DEST_DIR}" -name "*.html" -type f -exec sed -i '' 's|//images|/images|g' {} +

echo "Static site processing completed successfully!" 