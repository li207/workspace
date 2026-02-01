# Agent Testing Framework

Automated testing framework for TODO, workspace, and visual agents with complete isolation from production data.

## Quick Start

```bash
# Run all tests
./tests/test-runner.sh

# Tests run in isolated environment, cleanup automatically
# Zero risk to production data
```

## Test Coverage

### Core Tests
- **TODO test data setup** - Validates synthetic test task creation
- **TODO file structure** - Verifies active.md and archive/ structure
- **Workspace directory structure** - Checks workspace and archive directories
- **Workspace creation capability** - Tests workspace folder creation
- **Production data isolation** - Ensures zero contamination

### Isolation Strategy
- **Temporary environment** - All tests run in `/tmp/workspace-test-*`
- **Config override** - Commands use test data directory during execution
- **Automatic cleanup** - Complete removal of test artifacts on exit
- **Zero production risk** - Production workspace-data never touched

## Test Architecture

```
tests/
├── test-runner.sh              # Main test execution script
├── test-isolation-strategy.md  # Detailed isolation approach
└── README.md                   # This file
```

## Adding Tests

To add new tests, edit `test-runner.sh`:

```bash
# Example new test function
test_new_functionality() {
    echo -e "${BLUE}Testing new functionality...${NC}"
    
    # Test setup
    # Test execution  
    # Verification
    
    if [[ condition ]]; then
        return 0  # Success
    else
        return 1  # Failure
    fi
}

# Add to test execution section
test_new_functionality
test_result $? "New functionality test"
```

## CI/CD Integration

The test framework is designed for CI/CD:

```yaml
# Example GitHub Actions step
- name: Run agent tests
  run: ./tests/test-runner.sh
```

- Self-contained - no external dependencies
- Fast execution - typically completes in seconds
- Clear exit codes - 0 for success, 1 for failure
- Detailed output - shows exactly what passed/failed

## Benefits

- **Zero Production Risk** - Complete isolation from live data
- **Reliable Results** - Clean state on every run
- **Easy Maintenance** - Simple bash scripts
- **CI/CD Ready** - Works in any Unix environment
- **Fast Feedback** - Quick validation of agent functionality

## Safety Features

- Temporary test directory automatically cleaned up
- Production config restored even if tests fail
- No permanent changes to system state
- Test data never touches production workspace

Run with confidence - this framework cannot damage your production workspace!