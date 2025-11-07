#!/bin/bash
# Disciple App Development Commands
# Usage: source scripts/dev_commands.sh

# Colors for better output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print header
echo -e "${BLUE}=== Disciple App Development Commands ===${NC}"
echo -e "Run these commands from the project root directory"

# Code generation commands
generate_code() {
  echo -e "${YELLOW}Generating code...${NC}"
  dart run build_runner build --delete-conflicting-outputs
  echo -e "${GREEN}Code generation complete!${NC}"
}

# Watch for changes and generate code
watch_code() {
  echo -e "${YELLOW}Watching for code changes...${NC}"
  dart run build_runner watch --delete-conflicting-outputs
  echo -e "${GREEN}Code generation watcher stopped${NC}"
}

# Clean build files
clean_build() {
  echo -e "${YELLOW}Cleaning build files...${NC}"
  flutter clean
  dart run build_runner clean
  flutter pub get
  echo -e "${GREEN}Clean complete!${NC}"
}

# Run tests with coverage
run_tests() {
  echo -e "${YELLOW}Running tests with coverage...${NC}"
  flutter test --coverage
  echo -e "${GREEN}Tests complete!${NC}"
}

# Format code
format_code() {
  echo -e "${YELLOW}Formatting code...${NC}"
  dart format lib test
  echo -e "${GREEN}Formatting complete!${NC}"
}

# Analyze code
analyze_code() {
  echo -e "${YELLOW}Analyzing code...${NC}"
  flutter analyze
  echo -e "${GREEN}Analysis complete!${NC}"
}

# Build APK
build_apk() {
  echo -e "${YELLOW}Building APK...${NC}"
  flutter build apk --release
  echo -e "${GREEN}APK build complete!${NC}"
}

# Build App Bundle
build_aab() {
  echo -e "${YELLOW}Building App Bundle...${NC}"
  flutter build appbundle --release
  echo -e "${GREEN}App Bundle build complete!${NC}"
}

# Run app in development mode
run_dev() {
  echo -e "${YELLOW}Running app in development mode...${NC}"
  flutter run --flavor development --target lib/main_development.dart
}

# Run app in production mode
run_prod() {
  echo -e "${YELLOW}Running app in production mode...${NC}"
  flutter run --flavor production --target lib/main_production.dart
}
<<<<<<< HEAD
=======
# Get app dependencies
get_dependencies() {
  echo -e "${YELLOW}Getting app dependencies...${NC}"
  flutter pub get
}

# Update app dependencies
update_dependencies() {
  echo -e "${YELLOW}Updating app dependencies...${NC}"
  flutter pub upgrade
}
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b

# Display available commands
echo -e "${GREEN}Available commands:${NC}"
echo -e "${YELLOW}generate_code${NC} - Generate code with build_runner"
echo -e "${YELLOW}watch_code${NC} - Watch for changes and generate code"
echo -e "${YELLOW}clean_build${NC} - Clean build files and get dependencies"
echo -e "${YELLOW}run_tests${NC} - Run tests with coverage"
echo -e "${YELLOW}format_code${NC} - Format code with dart format"
echo -e "${YELLOW}analyze_code${NC} - Analyze code with flutter analyze"
echo -e "${YELLOW}build_apk${NC} - Build APK for release"
echo -e "${YELLOW}build_aab${NC} - Build App Bundle for release"
echo -e "${YELLOW}run_dev${NC} - Run app in development mode"
echo -e "${YELLOW}run_prod${NC} - Run app in production mode"
<<<<<<< HEAD
=======
echo -e "${YELLOW}get_dependencies${NC} - Get app dependencies"
echo -e "${YELLOW}update_dependencies${NC} - Update app dependencies"

>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
