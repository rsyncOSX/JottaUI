## JottaUI

JottaUI is a refreshed SwiftUI macOS app based on JottaUI. It keeps the same Jotta CLI workflows and project settings, while presenting them through an updated command-center interface.

Requirements:

- macOS Tahoe
- Xcode 26
- Swift 6.2
- Apple Silicon Mac
- `jotta-cli` configured by logging in from Terminal before using the app

Build notes:

- Target: `JottaUI`
- Bundle identifier: `no.blogspot.JottaUI`
- Architectures: `arm64` only, with `x86_64` excluded
- Sandbox: disabled in `JottaUI/JottaUI.entitlements`
