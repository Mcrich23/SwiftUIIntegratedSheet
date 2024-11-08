# SwiftUIIntegratedSheet

SwiftUIIntegratedSheet is a Swift Package that provides an easy way to present sheets or modals in SwiftUI, with built-in integration and a seamless user experience. This package simplifies the presentation logic, making sheet handling intuitive and customizable.

## Features

- **Simple API**: Easily present and dismiss sheets using SwiftUI-friendly syntax.
- **Customizable Appearance**: Configure the look and behavior of your sheet presentation.
- **Integration**: Works well with existing SwiftUI views and integrates seamlessly.

## Requirements

- **iOS**: Version 18.0 or later
- **macOS**: Version 14.0 or later
- **Xcode**: Version 16.0 or later
- **Swift**: Version 5.5 or later

## Installation

### Using Swift Package Manager

1. Open your project in Xcode.
2. Navigate to **File > Swift Packages > Add Package Dependency**.
3. Enter the repository URL: `https://github.com/mcrich23/SwiftUIIntegratedSheet.git`
4. Select the version you want to install.
5. Click **Finish** to add the package to your project.

## Usage

### Importing the Package

To use `SwiftUIIntegratedSheet`, import it at the top of your Swift file:

```swift
import SwiftUIIntegratedSheet
```

## Presenting a Sheet

To present a sheet using `SwiftUIIntegratedSheet`, follow these steps:

1. Create a `@State` variable to manage the sheet's visibility.
2. Use the `.integratedSheet(_:)` view modifier to handle sheet presentation.

### Recommended Usage: `SheetContainer`

`SheetContainer` is a view component that provides a structured way to present content within a customizable sheet. It can include a custom header section and a main content area.

#### Basic Example

```swift
import SwiftUI
import SwiftUIIntegratedSheet

struct ContentView: View {
    @State private var isSheetShown = false

    var body: some View {
        Button("Show Sheet") {
            isSheetShown = true
        }
        .integratedSheet(isPresented: $isSheetShown) {
            SheetContainer(
                title: "Example Sheet",
                isShown: $isSheetShown
            ) {
                Text("This is the main content of the sheet.")
                    .padding()
            }
        }
    }
}
```

#### Example with a Custom Header

You can also provide a custom header view:

```swift
import SwiftUI
import SwiftUIIntegratedSheet

struct ContentView: View {
    @State private var isSheetShown = false

    var body: some View {
        Button("Show Sheet") {
            isSheetShown = true
        }
        .integratedSheet(isPresented: $isSheetShown) {
            SheetContainer(
                title: "Custom Sheet",
                isShown: $isSheetShown,
                header: {
                    HStack {
                        Text("Custom Header")
                            .font(.headline)
                        Spacer()
                    }
                    .padding()
                }
            ) {
                Text("Content goes here.")
                    .padding()
            }
        }
    }
}
```

### `SheetContainer` Parameters

- **title**: The title of the sheet.
- **isShown**: A `Binding<Bool>` to control the visibility of the sheet.
- **header**: An optional header view, provided using a closure.
- **content**: The main content of the sheet, provided using a closure.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
