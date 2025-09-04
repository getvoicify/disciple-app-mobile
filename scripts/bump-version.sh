#!/bin/bash

# Version bumping script for Flutter app
# Usage: ./scripts/bump-version.sh [major|minor|patch|build]

set -e

BUMP_TYPE=${1:-patch}
PUBSPEC_FILE="pubspec.yaml"

# Check if pubspec.yaml exists
if [ ! -f "$PUBSPEC_FILE" ]; then
    echo "Error: pubspec.yaml not found!"
    exit 1
fi

# Extract current version
CURRENT_VERSION_LINE=$(grep "^version:" "$PUBSPEC_FILE")
CURRENT_VERSION=$(echo "$CURRENT_VERSION_LINE" | cut -d' ' -f2)
VERSION_NAME=$(echo "$CURRENT_VERSION" | cut -d'+' -f1)
VERSION_CODE=$(echo "$CURRENT_VERSION" | cut -d'+' -f2)

# Parse version components
IFS='.' read -r -a VERSION_PARTS <<< "$VERSION_NAME"
MAJOR="${VERSION_PARTS[0]:-0}"
MINOR="${VERSION_PARTS[1]:-0}"
PATCH="${VERSION_PARTS[2]:-0}"

echo "Current version: $VERSION_NAME+$VERSION_CODE"

# Bump version based on type
case "$BUMP_TYPE" in
    major)
        MAJOR=$((MAJOR + 1))
        MINOR=0
        PATCH=0
        VERSION_CODE=$((VERSION_CODE + 1))
        ;;
    minor)
        MINOR=$((MINOR + 1))
        PATCH=0
        VERSION_CODE=$((VERSION_CODE + 1))
        ;;
    patch)
        PATCH=$((PATCH + 1))
        VERSION_CODE=$((VERSION_CODE + 1))
        ;;
    build)
        # Only increment build number
        VERSION_CODE=$((VERSION_CODE + 1))
        ;;
    *)
        echo "Invalid bump type. Use: major, minor, patch, or build"
        exit 1
        ;;
esac

# Construct new version
NEW_VERSION_NAME="${MAJOR}.${MINOR}.${PATCH}"
NEW_VERSION="${NEW_VERSION_NAME}+${VERSION_CODE}"

echo "New version: $NEW_VERSION"

# Update pubspec.yaml
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s/^version: .*/version: $NEW_VERSION/" "$PUBSPEC_FILE"
else
    # Linux
    sed -i "s/^version: .*/version: $NEW_VERSION/" "$PUBSPEC_FILE"
fi

# Output for GitHub Actions
if [ -n "$GITHUB_OUTPUT" ]; then
    echo "version=$NEW_VERSION_NAME" >> "$GITHUB_OUTPUT"
    echo "version_code=$VERSION_CODE" >> "$GITHUB_OUTPUT"
    echo "full_version=$NEW_VERSION" >> "$GITHUB_OUTPUT"
    echo "tag=v$NEW_VERSION_NAME" >> "$GITHUB_OUTPUT"
fi

echo "Version bumped successfully!"
echo ""
echo "Next steps:"
echo "1. Review the changes: git diff pubspec.yaml"
echo "2. Commit: git add pubspec.yaml && git commit -m \"chore: bump version to $NEW_VERSION\""
echo "3. Tag: git tag v$NEW_VERSION_NAME"
echo "4. Push: git push && git push --tags"