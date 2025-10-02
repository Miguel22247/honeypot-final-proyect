#!/bin/bash

# Script to fix common markdown linter errors
# Author: Miguel Pacheco y Rolando Quiroz
# This script adds proper spacing around headings and lists

fix_markdown_file() {
    local file="$1"
    if [ ! -f "$file" ]; then
        echo "File not found: $file"
        return 1
    fi
    
    echo "Fixing markdown linter errors in: $file"
    
    # Create backup
    cp "$file" "${file}.backup"
    
    # Use sed to fix common issues
    # Add blank line before headings (except at start of file)
    # Add blank lines around lists
    # Add blank lines around code blocks
    
    awk '
    BEGIN { prev_line = ""; in_list = 0; in_code = 0 }
    {
        current_line = $0
        
        # Handle code blocks
        if (match($0, /^```/)) {
            if (in_code == 0) {
                if (prev_line != "" && prev_line !~ /^$/) print ""
                in_code = 1
            } else {
                in_code = 0
                print $0
                if (getline > 0) {
                    if ($0 !~ /^$/) print ""
                    print $0
                    prev_line = $0
                    next
                }
            }
        }
        
        # Handle headings
        if (match($0, /^#{1,6} /)) {
            if (NR > 1 && prev_line != "" && prev_line !~ /^$/) {
                print ""
            }
            print $0
            prev_line = $0
            next
        }
        
        # Handle lists
        if (match($0, /^[-*+] /) || match($0, /^[0-9]+\. /)) {
            if (in_list == 0 && prev_line != "" && prev_line !~ /^$/) {
                print ""
            }
            in_list = 1
            print $0
            prev_line = $0
            next
        } else if (in_list == 1 && $0 ~ /^$/) {
            in_list = 0
        } else if (in_list == 1 && !match($0, /^[-*+] /) && !match($0, /^[0-9]+\. /) && !match($0, /^  /)) {
            print ""
            in_list = 0
        }
        
        print $0
        prev_line = $0
    }
    ' "${file}.backup" > "$file"
    
    echo "Fixed: $file"
}

# Fix all markdown files in docs directory
for file in docs/*.md; do
    if [ -f "$file" ]; then
        fix_markdown_file "$file"
    fi
done

# Fix markdown files in config directory
for file in config/*.md; do
    if [ -f "$file" ]; then
        fix_markdown_file "$file"
    fi
done

# Fix root level markdown files
for file in *.md; do
    if [ -f "$file" ]; then
        fix_markdown_file "$file"
    fi
done

echo "Markdown linter error fixes completed!"
echo "Backup files created with .backup extension"
