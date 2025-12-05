# JottaUI - AI Coding Agent Instructions

## Project Overview
JottaUI is a SwiftUI-based macOS application (Xcode 16, Swift 6) providing a GUI wrapper around the `jotta-cli` command-line client for Jottacloud backup management. The app bridges the gap between user actions and shell command execution, displaying structured output from jotta-cli operations.

## Architecture Principles

### Command Execution Pattern
- All external jotta-cli commands execute via `ProcessCommand` (imported from ProcessCommand framework)
- Command handlers created in `Model/CreateHandlers/CreateCommandHandlers.swift` define callbacks for:
  - `processtermination`: Handles command completion with output and error state
  - `checklineforerror`: Error parsing via `CheckForError().checkforerror(_:)`
  - `updateprocess`: Progress tracking through `SharedReference.shared.updateprocess`
  - `logger`: Async logging to file via `ActorJottaUILogToFile`
- All process execution is `@MainActor` constrained to ensure UI thread safety

### Observable/State Management
- Use `@Observable` + `@MainActor` for global state: `ObservableCatalogsforbackup`, `ObservableJottaOutput`, `ObservableJSONStatus`
- `SharedReference.shared` is the central singleton for app-wide references (error handlers, process state, jotta-cli path detection)
- Error handling flows through `SharedReference.shared.errorobject?.alert(error:)`

### Actor Pattern for Data Processing
Located in `Model/Storage/Actors/`:
- `ActorCreateOutputforview`: Transforms jotta-cli string output into `JottaCliOutputData` records
  - Use `@concurrent nonisolated` for thread-safe transformations without actor isolation overhead
  - Split newlines with `createaoutputnewlines()` or flatten with `createaoutput()`
- `ActorJottaUILogToFile`: Writes command output to `~/.jottad/jottaui.txt` (1MB rolling limit)
- `ActorJottaCliLogfile`: Parses jotta-cli's native logfile
- Similar actors for JSON conversion and dump data processing

### JSON Parsing
- `DecodeJSON.swift` is a custom JSON parser (not Codable); handles dynamic JSON structures from jotta-cli
- Status output parsed via `ObservableJSONStatus` → stored for backup catalog verification
- Use `DecodeJSON(parseJSON: stringOutput)` to parse raw command responses

## Key Workflows

### Building & Distribution
- **Debug build**: `make debug` → builds unsigned, opens .app without notarization
- **Release build**: `make build` → full workflow: archive → notarize (via xcrun) → sign → DMG packaging
- Notarization profile: "RsyncUI" (see Makefile)
- Both architectures: x86_64 Intel + ARM (Apple Silicon) via xcodebuild destinations

### Adding New jotta-cli Commands
1. Create Observable state class in `Model/Global/Observable{Feature}.swift` with `@Observable @MainActor`
2. Define execution in the class (e.g., `excutestatusjson()` pattern)
3. Pass process handlers from `CreateCommandHandlers.createcommandhandlers()`
4. Handle results in `processtermination` closure → update observable state
5. Create view in `Views/{Feature}/` that binds to observable

### View Organization
- `Views/MainView/SidebarMainView.swift`: Main navigation and layout
- Feature-specific views grouped: `Add/`, `Dump/`, `ImportExport/`, `StatusView/`, `Sync/`, `JottaCliLogfileView/`
- Reusable modifiers in `Views/Modifiers/`: `EditValueScheme`, `ValueSchemeView`, `MessageView`, `ButtonStyles`

## Code Patterns & Conventions

### Process Execution Pattern
```swift
// Standard execution flow in Observable classes
func executeCommand() {
    let handlers = CreateCommandHandlers().createcommandhandlers(
        processtermination: { output, hasError in
            // Handle output, update @Observable state
            self.results = processedOutput
        })
    let process = ProcessCommand(
        command: FullpathJottaCli().jottaclipathandcommand(),
        arguments: ["command", "--arg"],
        handlers: handlers,
        syncmode: nil,
        input: nil)
    do {
        try process.executeProcess()
    } catch {
        SharedReference.shared.errorobject?.alert(error: error)
    }
}
```

### jotta-cli Path Discovery
- `FullpathJottaCli()`: Detects jotta-cli location (/usr/local/bin or /opt/homebrew/bin for ARM)
- `SharedReference.shared.macosarm`: Boolean flag for ARM detection
- Check path validity before command execution

### File Operations
- `FileManager.default.fileExists()` for catalog verification
- Log directory: `~/.jottad/` (hardcoded in SharedConstants)
- Logfile rotation at 1MB (see ActorJottaUILogToFile)

### Thread Safety
- All UI updates must be `@MainActor` (enforced at class level)
- Actor methods use `@concurrent nonisolated` for CPU-bound transformations (no blocking on shared state)
- Logger calls in handlers are async: `Logger.process.debugtthreadonly()` for conditional debug logging

### Error Handling
- Errors checked line-by-line via `CheckForError().checkforerror(line)` during command output streaming
- User-facing errors propagated through `AlertError` observable
- Include thread context in debug messages: "Running on main thread" vs "NOT on main thread"

## File Structure Reference
- **Entry point**: `JottaUI/Main/JottaUIApp.swift` (SwiftUI @main app + Logger extensions)
- **State layer**: `Model/Global/` (Observables, SharedReference, constants, error definitions)
- **Process layer**: `Model/Process/` (error checking, process interruption)
- **Data layer**: `Model/Storage/Actors/`, `Model/Storage/Json/` (transformations, persistence)
- **JSON parsing**: `Model/JSON/DecodeJSON.swift` (custom parser for jotta-cli JSON output)
- **UI layer**: `Views/` (feature-organized SwiftUI views and modifiers)

## Dependencies
- **ProcessCommand**: Manages external process execution (framework, not in repo)
- **SwiftyJSON**: Listed in README but custom `DecodeJSON` is primary JSON handler
- **OSLog**: System logging with custom Logger extensions in JottaUIApp.swift
- **Swift Concurrency**: async/await, actors, @MainActor throughout

## Important Notes
- Xcode version 16+ and Swift 6 required (may include experimental features)
- macOS Tahoe+ target
- No test files in repo structure; focus on compile-time safety via Swift type system
- swiftlint configured (note disable directives in app files)
