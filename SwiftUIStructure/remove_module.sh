#!/bin/sh

#  remove_module.sh
#  SwiftUIStructure
#
#  Created by Mengchea Saro on 12/6/26.
#  

# Exit immediately if a command exits with a non-zero status
set -e

# Prompt user for the module name if not passed as an argument
if [ -z "$1" ]
then
    read -p "Enter module name to REMOVE (e.g., User): " MODULE_NAME
else
    MODULE_NAME=$1
fi

# Ensure the first letter is capitalized
MODULE_NAME="$(tr '[:lower:]' '[:upper:]' <<< "${MODULE_NAME:0:1}")${MODULE_NAME:1}"

echo "⚠️  Preparing to delete Clean Architecture layers for: ${MODULE_NAME}..."

# Define specific file paths
FILE_API="API/${MODULE_NAME}API.swift"
FILE_DATASOURCE="Domain/DataSource/${MODULE_NAME}DataSource.swift"
FILE_REPO_IMPL="Domain/Repository/${MODULE_NAME}Repository.swift"
FILE_USECASE="Domain/UseCase/${MODULE_NAME}UseCase.swift"
DIR_PRESENTATION="Presentation/${MODULE_NAME}"
DI_FILE="DI/${MODULE_NAME}Container.swift"

# Track if anything was actually deleted
DELETED_ANYTHING=false

# Helper function to remove a file safely
remove_file() {
    if [ -f "$1" ]; then
        rm "$1"
        echo "🗑️  Deleted file: $1"
        DELETED_ANYTHING=true
    fi
}

# 1. Remove individual shared-layer files
remove_file "$FILE_API"
remove_file "$FILE_DATASOURCE"
remove_file "$FILE_REPO_IMPL"
remove_file "$FILE_USECASE"
remove_file "$DI_FILE"

# 2. Remove the Presentation directory entirely
if [ -d "$DIR_PRESENTATION" ]; then
    rm -rf "$DIR_PRESENTATION"
    echo "🗑️  Deleted directory: $DIR_PRESENTATION/"
    DELETED_ANYTHING=true
fi

# 3. Completion block
if [ "$DELETED_ANYTHING" = true ]; then
    echo "✅ Success! All files associated with ${MODULE_NAME} have been removed."
    
    # Run XcodeGen automatically to clean up the project hierarchy
    if command -v xcodegen &> /dev/null; then
        echo "🔄 Re-syncing Xcode project via XcodeGen..."
#        xcodegen generate
        cd /Users/mengchea.sar/Documents/SwiftUI/SwiftUIStructure/SwiftUIStructure/ xcodegen generate
    else
        echo "💡 Tip: Run 'xcodegen generate' if you use XcodeGen to refresh your Xcode project file."
    fi
else
    echo "ℹ️  No files found for module '${MODULE_NAME}'. Nothing to delete."
fi
