#!/bin/bash

# Color definitions
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}============================================${NC}"
echo -e "${CYAN}NumberSense Test Watcher${NC}"
echo -e "${BLUE}============================================${NC}"
echo -e "${YELLOW}Watching for changes and running tests...${NC}"
echo -e "Press Ctrl+C to stop\n"

last_run=0
cooldown=2 # seconds between test runs to avoid excessive testing

while true; do
  current_time=$(date +%s)
  time_diff=$((current_time - last_run))
  
  # Check if any source files have changed since the last run
  changes=$(find lib test -type f -name "*.dart" -newer /tmp/numbersense_last_test 2>/dev/null)
  
  if [[ ! -z "$changes" && $time_diff -ge $cooldown ]]; then
    echo -e "\n${YELLOW}Changes detected! Running tests...${NC}"
    echo -e "${CYAN}$(date)${NC}"
    
    # Clear terminal for better readability
    printf "\033c"
    
    # Run Flutter tests with nice formatting
    echo -e "${BLUE}============================================${NC}"
    echo -e "${CYAN}NumberSense Test Watcher - Running Tests${NC}"
    echo -e "${BLUE}============================================${NC}"
    echo -e "${YELLOW}Changed files:${NC}"
    echo "$changes" | sed 's/^/  /'
    echo -e "${BLUE}--------------------------------------------${NC}"
    
    # Run the tests
    flutter test
    
    # Store result
    test_result=$?
    
    # Update last run time
    last_run=$(date +%s)
    touch /tmp/numbersense_last_test
    
    # Print result summary
    echo -e "${BLUE}--------------------------------------------${NC}"
    if [ $test_result -eq 0 ]; then
      echo -e "${GREEN}✓ All tests passed!${NC}"
    else
      echo -e "${RED}✗ Some tests failed!${NC}"
    fi
    echo -e "${BLUE}============================================${NC}"
    echo -e "${YELLOW}Watching for more changes...${NC}"
    echo -e "Press Ctrl+C to stop\n"
  fi
  
  # Create the file if it doesn't exist yet
  if [ ! -f /tmp/numbersense_last_test ]; then
    touch /tmp/numbersense_last_test
  fi
  
  # Sleep for a short while to avoid high CPU usage
  sleep 1
done