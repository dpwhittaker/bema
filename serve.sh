#!/bin/bash
# Serve Jekyll site locally for development

echo "Starting Jekyll development server..."
echo "Site will be available at: http://localhost:4000"
echo "Add ?print to any URL to preview print styles"
echo ""

bundle exec jekyll serve --livereload
