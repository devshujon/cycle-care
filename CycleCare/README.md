# CycleCare (iOS)

Native **Swift + SwiftUI** women's wellness and period tracking app (MVVM, SwiftData, Firebase Auth/FCM, StoreKit 2, AdMob).

## Requirements

- Xcode 15+
- iOS 17+
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`)

## Setup

1. Generate the Xcode project:

   ```bash
   cd CycleCare
   xcodegen generate
   open CycleCare.xcodeproj
   ```

2. **Firebase**: Copy `CycleCare/Resources/GoogleService-Info.plist.example` to `CycleCare/Resources/GoogleService-Info.plist` and replace values from the [Firebase Console](https://console.firebase.google.com). Enable Email/Password and Apple Sign-In.

3. **Signing**: Select your Team in Xcode → CycleCare target → Signing & Capabilities.

4. **StoreKit**: Create subscription products matching `AppConstants.StoreKit` IDs in App Store Connect, or add a local `Configuration.storekit` file in Xcode for testing.

5. **AdMob**: Replace test ad unit IDs in `AppConstants.AdMob` and `Info.plist` (`GADApplicationIdentifier`) with production IDs before release.

## Build on device

Select your iPhone as the run destination and press **⌘R**. After schema changes, delete the old app from the device before reinstalling.

## Architecture

| Layer | Location |
|--------|-----------|
| App entry | `CycleCare/App/` |
| Models (SwiftData) | `CycleCare/Models/` |
| Services | `CycleCare/Services/` |
| ViewModels | `CycleCare/ViewModels/` |
| Views | `CycleCare/Views/` |
| Components | `CycleCare/Components/` |
| EN / BN strings | `CycleCare/Resources/*.lproj/` |

## Known compile fixes (v2.0)

- `AdSlot(adUnitID: AppConstants.AdMob.banner)` — banner requires an ad unit ID.
- SwiftUI `Section("title") { } footer: { }` is invalid; use `header:` + `footer:` with a titleless `Section { }`.
- Subscription overlay uses `Color.black.opacity(0.4).ignoresSafeArea()` as a `View`, not inside `.background(_: ShapeStyle)`.

## Disclaimer

CycleCare supports personal wellness tracking and education. It does not provide medical diagnosis or treatment.
