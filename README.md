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

## Features to explore

### Swift Scripting
- This package uses a executable target a feature available in Swift Package.
```swift
.executableTarget(
    name: "GenerateReadMe",
    dependencies: [
        "Models",
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .product(name: "Yams", package: "Yams")
    ]
)
```
- This allows us to run the script similar to how we run Xcode projects.
- As mentioned above this can also be run using command line, this command excepts a path to be executed, so this can also be configured with Xcode's scheme editor, going for the run's Arguments tab and setting the argument passed on launch for path to `/Users/username/path-to/Talks`. (Note: this is the talks directory path from Swift-Ahmedabad's [Talks Repository](https://github.com/Swift-Ahmedabad/Talks)).

### Argument Parser
- This package uses an open source project [Argument Parser](https://github.com/apple/swift-argument-parser)
```swift
@main
struct GenerateReadMe: ParsableCommand {
    
    static var configuration: CommandConfiguration {
        CommandConfiguration(commandName: "GenerateReadMe")
    }
    
    @Argument(help: "Path of the Talks Directory")
    var path: String
     
    ...
    
    func run() throws {
        // Reading the argument variables and executing normal swift code.
        ...
    }
}
```

### YML Parsing
- This package uses the [Yams](https://github.com/jpsim/Yams) library for decoding the YML file. (Generally used for the configuration)
- Yams library comes with `YMLDecoder` with very similar apis to Swift's `JSONDecoder`.
```swift
let decoder = YAMLDecoder()
let contentData = FileManager.default.contents(atPath: talkContentURL.path(percentEncoded: false)
let decodedSpeakers = try decoder.decode([Speaker].self, from: contentData)
``` 

### FileManager
- FileManager is used to read the files in the `Talks` directory. 
- General function `(URL) -> Data`
```swift
let aboutPath = URL(filePath: path).appending(path: ".about").appending(path: "About.yaml")
if let aboutContent = FileManager.default.contents(atPath: aboutPath.path(percentEncoded: false)) {
    let aboutPage = try decoder.decode(AboutPage.self, from: aboutContent)
    info.about = aboutPage
}
```

### Markdown & json file generation
- The Generator file contains two functions
1. `generateReadMe(for:at)`
2. `generateJson<T>(for:at:encoder)`

- To generate the Markdown file from the defined Models, Models structures conforms to `CustomStringConvertible` protocol and it's description is having markdown syntax for its content.
```
let content = events.map { $0.description }.joined(separator: "\n")
try content.write(to: path, atomically: true, encoding: .utf8)
```

- To generate the json file, using simple JSONEncoder with `.prettyPrinted` and `.sortedKeys` output formatting options
```
encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
let data = try encoder.encode(item)
try data.write(to: path)
```

### DecodableWithConfiguration
- There are some cases when simple JSONDecoder is not enough. 
- For example, `Agenda` type does not include the date components (`MMMM dd, yyyy`) in `time` variable (`hh:mm a`) in the YML file, so it is passed from the parent JSONDecoder. [See `Agenda.swift` file from **Models** directory].
- `DecodableWithConfiguration` comes with a special initializer with extra `configuration` parameter.
```
public struct Agenda: Identifiable, Codable, DecodableWithConfiguration {
    public var id: String
    public var eventID: Event.ID
    public var time: Date

    public init(from decoder: any Decoder, configuration: String) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let timeString = try container.decode(String.self, forKey: .time)
        
        dateFormatter.dateFormat = "MMMM dd, yyyy hh:mm a"
        guard let time = dateFormatter.date(from: "\(configuration) \(timeString)") else {
            throw someError
        }
        
        self.time = time
    }
}
```

### StableID using CryptoKit
- The Generated data can be used to store in a persistence storage system like Database, the identifier of the generated json items needs to be stable in every code generation.
- So `StableID` is defined to generate a consistent ids for the defined structure types.
- `StableID` takes variadic arguments of `Encodable` types,
- Uses SHA256 hashing function from `CryptoKit`.

```swift
public struct StableID: CustomStringConvertible, Codable, Identifiable, Hashable, Sendable {
    
    public var id: String
    
    public init(using fields: any Encodable...) {
        let data = fields.compactMap { try? JSONEncoder().encode($0) }.joined()
        let digest = SHA256.hash(data: Data(data))
        self.id = digest.map { String(format: "%02x", $0) }.joined()
    }
    
}
```  

### Unit Testing with Snapshot Testing

- This package's primary purpose is to generate a Readme markdown file and bunch of json files.
- To have a unit test that can detect the changes in the generated files would be a good solution for updating the script and still getting the correctly formatted output.
- To achieve this [SnapshotTesting](https://github.com/pointfreeco/swift-snapshot-testing) is used. 
- It requires only to write the test for the code generation and it will generate the output inline and for the future test run, it will compare the generated output with the new run and fails if it differs.

```swift
@Test func generateSpeakersJson() throws {
    try withSnapshotTesting {
        let events = try Parser.events(from: fileURL.path(percentEncoded: false)).speakers
        let jsonURL = fileURL.appending(path: "speakers.json")
        try Generator.generateJson(for: events, at: jsonURL)
        assertInlineSnapshot(of: jsonURL, as: .jsonURLContent)
    }
}
```

- In the first run, it will record the output and write it down inline like this
```swift
@Test func generateSpeakersJson() throws {
    try withSnapshotTesting {
        let events = try Parser.events(from: fileURL.path(percentEncoded: false)).speakers
        let jsonURL = fileURL.appending(path: "speakers.json")
        try Generator.generateJson(for: events, at: jsonURL)
        assertInlineSnapshot(of: jsonURL, as: .jsonURLContent) {
            #"""
            [
                {
                    "about" : "Apple Engineer",
                    "id" : "de3a6933de1304cc65729639ffe1f6101f06647be726d9c176283bdf7e4b0173",
                    "name" : "Johny Appleseed",
                    "socials" : {
                        "github" : "https:\/\/github.com\/johny-appleseed",
                        "linkedIn" : "https:\/\/www.linkedin.com\/in\/johny-appleseed-0a0123456\/",
                        "portfolio" : "https:\/\/johny-appleseed.github.io"
                    }
                }
            ]
            """#
        }
    }
}
```
- And, in the next run it will directly compare the newly generated code with recorded code line by line and fails if it differs.

### Custom Snapshotting Strategy
- This package also uses a custom Snapshotting strategy to output json formatted content from the file URL

```swift
extension Snapshotting where Value == URL, Format == String {
    static let jsonURLContent = Snapshotting(pathExtension: "json", diffing: .lines) { value in
        if let json = try? JSONSerialization.jsonObject(with: Data(contentsOf: value)),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted, .sortedKeys]) {
            return String(decoding: jsonData, as: UTF8.self)
        }
        return ""
    }
}
```

- Usage:
```swift
let jsonURL = fileURL.appending(path: "speakers.json")
assertInlineSnapshot(of: jsonURL, as: .jsonURLContent)
```
