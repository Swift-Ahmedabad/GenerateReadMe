# GenerateReadMe

A Swift command-line tool that parses a directory of event talks (with YAML files) and generates:
- A Markdown README summarizing events, talks, and speakers
- JSON exports for events, speakers, talks, and talk–speaker relationships

This package is built with Swift Package Manager and is suitable for automation in CI or local scripts.

## Package Overview

- Targets
  - `Models` (target): Domain models used across the package (e.g., `Event`, `Talk`, `Speaker`, `TalkSpeaker`, and composites like `EventWithTalks`, `TalkWithSpeakers`).
  - `GenerateReadMe` (executable target): The CLI tool that parses content and generates outputs. Depends on `Models`, `ArgumentParser`, and `Yams`.
  - `GenerateReadMeTests` (test target): Snapshot and inline-snapshot tests that validate parsing and generation behavior.

- Dependencies
  - `swift-argument-parser` (ArgumentParser): Command-line argument parsing for the executable.
  - `Yams`: YAML decoding for speaker files.
  - `swift-snapshot-testing`: Snapshot testing utilities (test-only) including `SnapshotTesting`, `SnapshotTestingCustomDump`, and `InlineSnapshotTesting`.

See Package.swift for exact versions.

## Requirements

- Swift 6.2+
- macOS 14+ (package declares `.macOS(.v26)` which corresponds to Xcode 16+ toolchains)

## Directory Structure Expectations

The parser expects a directory layout like the following under your chosen root `path`:

## Running from Xcode

You can run the `GenerateReadMe` executable directly in Xcode.

1. Open the package in Xcode (File > Open… and select the package folder).
2. In the scheme selector (next to the Play button), choose the `GenerateReadMe` scheme.
3. Provide the required arguments:
   - Product > Scheme > Edit Scheme…
   - Select the Run action
   - Go to the Arguments tab
   - Under "Arguments Passed On Launch", add the path to your Talks directory, for example: `~/Development/Swift\ Ahmedabad/Talks`

## Build, Run, and Export from the Command Line

### 1) Build the Executable

```bash
# Debug build (fast iteration)
swift build

# Release build (optimized binary)
swift build -c release

# Executable locations:
#   .build/debug/GenerateReadMe
#   .build/release/GenerateReadMe
```

### 2) Run from Command line

```bash
# Running using `swift run`
swift run GenerateReadMe ~/Development/Swift\ Ahmedabad/Talks 

# Running using generated executable, 
./.build/release/GenerateReadMe ~/Development/Github/Swift\ Ahmedabad/Talks
```

### 3) Exporting the executable
- Build the executable in release mode using
```bash
swift build -c release && cp ./.build/release/GenerateReadMe ~/<your-desired-directory>/GenerateReadMe
```

## Testing 
You can run the tests using `Xcode` as well as from `Command line`

### Testing using `Xcode`
Press `⌘ Command` + `U`

### Testing from Command Line
```bash
swift test
```
