#!/bin/bash

# Generate release notes from git commits
# Usage: ./scripts/generate-release-notes.sh [last-tag] [current-tag]

set -e

# Get tags
LAST_TAG=${1:-$(git describe --tags --abbrev=0 2>/dev/null || echo "")}
CURRENT_TAG=${2:-HEAD}

echo "Generating release notes..."
echo "From: ${LAST_TAG:-beginning}"
echo "To: $CURRENT_TAG"
echo ""

# Determine commit range
if [ -z "$LAST_TAG" ]; then
    COMMIT_RANGE="$CURRENT_TAG"
else
    COMMIT_RANGE="${LAST_TAG}..${CURRENT_TAG}"
fi

# Function to format commit message
format_commit() {
    local commit=$1
    local message=$2
    local short_hash=$(echo "$commit" | cut -c1-7)
    echo "- $message ($short_hash)"
}

# Get all commits
COMMITS=$(git log $COMMIT_RANGE --pretty=format:"%H|%s" --no-merges)

# Initialize categories
FEATURES=""
FIXES=""
PERFORMANCE=""
REFACTOR=""
DOCS=""
TESTS=""
CHORES=""
BREAKING=""
OTHER=""

# Process commits
while IFS='|' read -r hash message; do
    # Skip empty lines
    [ -z "$hash" ] && continue
    
    # Check for breaking changes
    if echo "$message" | grep -qE "^(feat!|fix!|BREAKING CHANGE)"; then
        BREAKING="${BREAKING}$(format_commit "$hash" "$message")\n"
    # Categorize by conventional commit type
    elif echo "$message" | grep -qE "^feat(\(.*\))?:"; then
        FEATURES="${FEATURES}$(format_commit "$hash" "$message")\n"
    elif echo "$message" | grep -qE "^fix(\(.*\))?:"; then
        FIXES="${FIXES}$(format_commit "$hash" "$message")\n"
    elif echo "$message" | grep -qE "^perf(\(.*\))?:"; then
        PERFORMANCE="${PERFORMANCE}$(format_commit "$hash" "$message")\n"
    elif echo "$message" | grep -qE "^refactor(\(.*\))?:"; then
        REFACTOR="${REFACTOR}$(format_commit "$hash" "$message")\n"
    elif echo "$message" | grep -qE "^docs(\(.*\))?:"; then
        DOCS="${DOCS}$(format_commit "$hash" "$message")\n"
    elif echo "$message" | grep -qE "^test(\(.*\))?:"; then
        TESTS="${TESTS}$(format_commit "$hash" "$message")\n"
    elif echo "$message" | grep -qE "^chore(\(.*\))?:"; then
        CHORES="${CHORES}$(format_commit "$hash" "$message")\n"
    else
        OTHER="${OTHER}$(format_commit "$hash" "$message")\n"
    fi
done <<< "$COMMITS"

# Generate release notes
RELEASE_NOTES=""

# Add breaking changes first
if [ -n "$BREAKING" ]; then
    RELEASE_NOTES="${RELEASE_NOTES}## ⚠️ BREAKING CHANGES\n\n${BREAKING}\n"
fi

# Add features
if [ -n "$FEATURES" ]; then
    RELEASE_NOTES="${RELEASE_NOTES}## ✨ Features\n\n${FEATURES}\n"
fi

# Add bug fixes
if [ -n "$FIXES" ]; then
    RELEASE_NOTES="${RELEASE_NOTES}## 🐛 Bug Fixes\n\n${FIXES}\n"
fi

# Add performance improvements
if [ -n "$PERFORMANCE" ]; then
    RELEASE_NOTES="${RELEASE_NOTES}## ⚡ Performance Improvements\n\n${PERFORMANCE}\n"
fi

# Add refactoring
if [ -n "$REFACTOR" ]; then
    RELEASE_NOTES="${RELEASE_NOTES}## ♻️ Code Refactoring\n\n${REFACTOR}\n"
fi

# Add documentation
if [ -n "$DOCS" ]; then
    RELEASE_NOTES="${RELEASE_NOTES}## 📝 Documentation\n\n${DOCS}\n"
fi

# Add tests
if [ -n "$TESTS" ]; then
    RELEASE_NOTES="${RELEASE_NOTES}## ✅ Tests\n\n${TESTS}\n"
fi

# Add chores (only if verbose or no other changes)
if [ -n "$CHORES" ] && [ "$VERBOSE" = "true" ]; then
    RELEASE_NOTES="${RELEASE_NOTES}## 🔧 Chores\n\n${CHORES}\n"
fi

# Add other changes
if [ -n "$OTHER" ]; then
    RELEASE_NOTES="${RELEASE_NOTES}## 📦 Other Changes\n\n${OTHER}\n"
fi

# Add statistics
COMMIT_COUNT=$(echo "$COMMITS" | wc -l | tr -d ' ')
CONTRIBUTOR_COUNT=$(git log $COMMIT_RANGE --pretty=format:"%an" --no-merges | sort -u | wc -l | tr -d ' ')
FILES_CHANGED=$(git diff --stat $COMMIT_RANGE | tail -1)

RELEASE_NOTES="${RELEASE_NOTES}## 📊 Statistics\n\n"
RELEASE_NOTES="${RELEASE_NOTES}- **Commits**: ${COMMIT_COUNT}\n"
RELEASE_NOTES="${RELEASE_NOTES}- **Contributors**: ${CONTRIBUTOR_COUNT}\n"
RELEASE_NOTES="${RELEASE_NOTES}- **Changes**: ${FILES_CHANGED}\n\n"

# Add contributors
CONTRIBUTORS=$(git log $COMMIT_RANGE --pretty=format:"@%an" --no-merges | sort -u | tr '\n' ' ')
if [ -n "$CONTRIBUTORS" ]; then
    RELEASE_NOTES="${RELEASE_NOTES}## 👥 Contributors\n\n${CONTRIBUTORS}\n\n"
fi

# Output release notes
echo -e "$RELEASE_NOTES"

# Save to file if requested
if [ -n "$OUTPUT_FILE" ]; then
    echo -e "$RELEASE_NOTES" > "$OUTPUT_FILE"
    echo "Release notes saved to: $OUTPUT_FILE"
fi

# Output for GitHub Actions
if [ -n "$GITHUB_OUTPUT" ]; then
    # Escape for GitHub Actions
    ESCAPED_NOTES=$(echo -e "$RELEASE_NOTES" | sed ':a;N;$!ba;s/\n/%0A/g')
    echo "release_notes=$ESCAPED_NOTES" >> "$GITHUB_OUTPUT"
fi