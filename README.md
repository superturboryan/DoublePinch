# DoublePinch

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsuperturboryan%2FDoublePinch%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/superturboryan/DoublePinch) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsuperturboryan%2FDoublePinch%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/superturboryan/DoublePinch)

`DoublePinch` adds double-pinch support to SwiftUI `Button`s on watchOS.

On supported Apple Watch models running watchOS 11 or newer, it uses the system hand gesture shortcut for the primary action. On earlier supported devices, it falls back to an accessibility quick action so the same button can still participate in a double-pinch driven flow.

## Requirements

- watchOS 9.0+
- Xcode 16+
- Swift 6

## Installation

Add the package from the repository URL:

```swift
dependencies: [
    .package(url: "https://github.com/superturboryan/DoublePinch.git", from: "1.0.0"),
]
```

Then add `DoublePinch` to your target dependencies:

```swift
.target(
    name: "MyWatchApp",
    dependencies: [
        .product(name: "DoublePinch", package: "DoublePinch"),
    ]
)
```

## Usage

Import the package and apply `.doublePinch()` to a SwiftUI `Button`:

```swift
import DoublePinch
import SwiftUI

struct ContentView: View {
    var body: some View {
        Button("Start Workout") {
            startWorkout()
        }
        .doublePinch()
    }

    private func startWorkout() {
        // Trigger your primary action here.
    }
}
```

### Choosing a mode

`DoublePinch` exposes these configuration options through `DoublePinchMode`:

- `.automatic`
- `.accessibilityQuickAction`
- `.doubleTapGesture` on watchOS 11+

On watchOS 11 and newer, `.automatic` upgrades to the system double-tap gesture when the hardware supports it. Otherwise it uses the accessibility quick action fallback.

In most cases, `.automatic` is the right default.

If you want to force the fallback behavior:

```swift
Button("Confirm") {
    confirm()
}
.doublePinch(.accessibilityQuickAction)
```

If you specifically want to choose the mode yourself, provide an explicit fallback:

```swift
if #available(watchOS 11.0, *) {
    Button("Pay") {
        submitPayment()
    }
    .doublePinch(.doubleTapGesture)
} else {
    Button("Pay") {
        submitPayment()
    }
    .doublePinch(.accessibilityQuickAction)
}
```

## How it works

- `Button.doublePinch()` attaches the package's gesture-aware view modifier.
- `.automatic` chooses between `handGestureShortcut(.primaryAction)` and `accessibilityQuickAction(style: .outline)` based on OS support and device capability.
- Explicit modes do exactly what you request, so use `.doubleTapGesture` only when you want the watchOS 11 gesture path.
- The current implementation reuses the button's primary action by introspecting the underlying `Button`, so it is worth validating on the watchOS versions and button styles you ship.

## License

`DoublePinch` is available under the MIT license. See [LICENSE.txt](LICENSE.txt).
