# Opus
libopus bindings for Swift

## Platform Support
This package should work on any platform that supports Swift.
The only prerequisite is that you need `libopus` installed to your system.
Use your package manager to install that.


## Usage
In your Package.swift, add the repository to your dependencies.
```swift
dependencies: [
    .package(url: "https://github.com/SketchMaster2001/Opus", .branch("master"))
],
    
targets: [
  .target(
    name: "yourswiftexecutablehere",
    dependencies: ["Opus"]
  )
 ]
)
```

Now you can import Opus and use it in your code.

```swift
import Opus

// Create encoder.
// We specify a sample rate of 48k, bitrate of 128k and 2 channels as this is what Discord expects.
// Change according to whatever purpose suits you.
let encoder = try! OpusEncoder(sampleRate: 48000, channels: 2, bitrate: 128000)

// The encoder takes either a Data object or UInt8 array.
let encoded: Data = encoder.encode(data)
```
