# Test Isolation Strategy

## Problem
Testing agents that manipulate real TODO and workspace files could:
- Corrupt production data
- Create test artifacts in live workspace
- Interfere with actual work
- Make tests unreliable due to existing data

## Isolation Approaches

### Option 1: Temporary Test Environment
Create isolated test workspace that gets cleaned up:

```bash
# Setup test environment
TEST_DATA_DIR="/tmp/workspace-test-$(date +%s)"
export WORKSPACE_DATA_DIR="$TEST_DATA_DIR"

# Create test structure
mkdir -p "$TEST_DATA_DIR"/{todo,workspace}
echo "# Test Tasks" > "$TEST_DATA_DIR/todo/active.md"

# Run tests in isolation
./test-suite.sh

# Cleanup
rm -rf "$TEST_DATA_DIR"
```

### Option 2: Backup/Restore Pattern
```bash
# Backup production data
cp -r workspace-data workspace-data.backup

# Run tests (may modify data)
./test-suite.sh

# Restore original data
rm -rf workspace-data
mv workspace-data.backup workspace-data
```

### Option 3: Docker Container Testing
```dockerfile
FROM alpine
COPY framework /workspace
WORKDIR /workspace
RUN ./bootstrap.sh
CMD ["./run-tests.sh"]
```

### Option 4: Test Configuration Override
Modify commands to accept test data directory:

```bash
# Override workspace path for testing
echo "WORKSPACE_DATA_DIR=/tmp/test-workspace" > ~/.claude/test-workspace-path.txt

# Commands check for test config first
if [[ -f ~/.claude/test-workspace-path.txt ]]; then
    source ~/.claude/test-workspace-path.txt
else
    source ~/.claude/workspace-path.txt
fi
```

## Recommended Approach: Temporary Environment

**Benefits:**
- Complete isolation from production
- No risk of data corruption
- Parallel test execution possible
- Easy cleanup

**Implementation:**
```bash
#!/bin/bash
# test-runner.sh

# Create isolated test environment
TEST_ID="test-$(date +%s)-$$"
TEST_DIR="/tmp/workspace-$TEST_ID"
export WORKSPACE_DATA_DIR="$TEST_DIR"

echo "🧪 Creating test environment: $TEST_DIR"

# Setup test workspace structure
mkdir -p "$TEST_DIR"/{todo/archive,workspace/archive}
echo "# Test Active Tasks" > "$TEST_DIR/todo/active.md"

# Override workspace config for this session
echo "WORKSPACE_DIR=/Users/lizhongzhang/Projects/workspace" > ~/.claude/test-workspace-path.txt
echo "WORKSPACE_DATA_DIR=$TEST_DIR" >> ~/.claude/test-workspace-path.txt

# Run tests
echo "🔬 Running tests..."
./tests/todo-agent-test.sh
./tests/workspace-agent-test.sh  
./tests/integration-test.sh

# Cleanup
echo "🧹 Cleaning up test environment..."
rm -rf "$TEST_DIR"
rm -f ~/.claude/test-workspace-path.txt

echo "✅ Tests complete"
```

## Test Data Patterns

### Synthetic Test Tasks
```bash
# Create predictable test data
cat > "$TEST_DIR/todo/active.md" << EOF
# Active Tasks

- [ ] Test task alpha #id:test01
  - priority: p1
  - created: 2026-02-01
  - context: Test task for framework validation

- [ ] Test task beta #id:test02  
  - priority: p2
  - created: 2026-02-01
  - due: 2026-02-03
  - context: Another test task with due date
EOF
```

### Expected State Verification
```bash
# Verify task creation
function test_task_creation() {
    local initial_count=$(grep -c "^- \[ \]" "$WORKSPACE_DATA_DIR/todo/active.md")
    
    # Run command
    /todo create "New test task"
    
    # Verify result
    local final_count=$(grep -c "^- \[ \]" "$WORKSPACE_DATA_DIR/todo/active.md")
    
    if (( final_count == initial_count + 1 )); then
        echo "✅ Task creation test passed"
    else
        echo "❌ Task creation test failed: expected $((initial_count + 1)), got $final_count"
        return 1
    fi
}
```

## File State Verification

Instead of testing implementation details, test observable behaviors:

```bash
# Test: TODO completion archives workspace
function test_todo_workspace_integration() {
    # Setup
    mkdir -p "$WORKSPACE_DATA_DIR/workspace/test01"
    echo "test content" > "$WORKSPACE_DATA_DIR/workspace/test01/test.txt"
    
    # Action
    echo "/todo complete test01" | claude-code
    
    # Verify
    if [[ -d "$WORKSPACE_DATA_DIR/workspace/archive/test01" ]]; then
        echo "✅ Workspace archived correctly"
    else
        echo "❌ Workspace not archived"
        return 1
    fi
}
```

## Benefits of This Approach

1. **Zero Production Risk** - No chance of corrupting real data
2. **Predictable State** - Tests start with known, clean state
3. **Parallel Execution** - Multiple test runs can't interfere
4. **Fast Cleanup** - Simple directory removal
5. **CI/CD Ready** - Works in any environment

This strategy ensures our tests are reliable, safe, and don't interfere with actual workspace usage!