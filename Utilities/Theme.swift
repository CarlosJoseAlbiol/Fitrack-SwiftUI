import SwiftUI

/// Central place for every color, gradient, and sizing constant the app
/// uses. Instead of hardcoding colors inside each screen (which makes
/// re-theming the app painful later), every View reaches into "Theme"
/// for its colors. Change a value here and it updates everywhere at once.
enum Theme {
    // We use "enum" with no cases here purely as a namespace — it can never
    // be instantiated, it just holds static constants under one clear name.

    static let background = Color(red: 0.05, green: 0.05, blue: 0.07)
    // The app's base near-black background color.

    static let cardBackground = Color(red: 0.11, green: 0.11, blue: 0.145)
    // A slightly lighter shade used behind cards, so they stand out against
    // the darker background without looking harsh.

    static let primaryAccent = Color(red: 1.00, green: 0.35, blue: 0.21)
    // The app's main brand color — an energetic orange-red used for
    // buttons, the protein ring, and highlighted icons.

    static let secondaryAccent = Color(red: 0.24, green: 0.86, blue: 0.52)
    // A fresh green used for anything related to progress/success, like
    // the workout-frequency ring and positive stat labels.

    static let tertiaryAccent = Color(red: 0.30, green: 0.55, blue: 1.00)
    // An electric blue used as a third accent for variety on stat cards
    // (height, BMI, goal weight) so not everything is orange or green.

    static let textPrimary = Color.white
    // Main text color — full white for maximum readability on dark backgrounds.

    static let textSecondary = Color.white.opacity(0.6)
    // A dimmed white for less important text (subtitles, captions), which
    // creates visual hierarchy without needing a second color.

    static let cardGradient = LinearGradient(
        colors: [primaryAccent, primaryAccent.opacity(0.65)],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    // A diagonal fade from full-strength to lighter orange, used on the
    // "Edit Profile" button so it doesn't look like a flat block of color.

    static let backgroundGradient = LinearGradient(
        colors: [Color(red: 0.07, green: 0.07, blue: 0.10), Color(red: 0.02, green: 0.02, blue: 0.035)],
        startPoint: .top, endPoint: .bottom
    )
    // A subtle top-to-bottom darkening used as the backdrop on every screen,
    // giving the app depth instead of one flat solid color.

    static let cornerRadius: CGFloat = 20
    // The rounding used on every card and button, kept as one constant so
    // all corners look consistent across the whole app.
}

extension View {
    // Extensions let us add new functionality to an existing type (in this
    // case, SwiftUI's built-in "View" protocol) without subclassing anything.

    func cardStyle() -> some View {
        // A reusable modifier: instead of writing
        // ".background(...).cornerRadius(...)" on every single card in the
        // app, we just write ".cardStyle()" once and get both effects.
        self
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadius)
    }
}
