import SwiftUI

/// REUSABLE COMPONENT (View)
/// A small rectangular tile that shows one statistic — an icon, a big
/// number, a title, and an optional colored subtitle. Used repeatedly on
/// the Dashboard (4 tiles) and Profile (4 tiles) screens, so instead of
/// writing this layout out by hand each time, we define it once here and
/// just pass in different text/colors wherever it's needed.
struct StatCardView: View {
    let title: String
    // The label under the big number, e.g. "Current Weight".

    let value: String
    // The big, bold number itself, e.g. "68 kg".

    let subtitle: String
    // Optional extra context shown in the accent color, e.g. "Goal: 74 kg".

    let icon: String
    // The SF Symbol name shown at the top of the card.

    let accentColor: Color
    // Lets each card be tinted differently (orange, green, or blue) so the
    // Dashboard doesn't look monotone.

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // VStack stacks its contents vertically. "alignment: .leading"
            // left-aligns everything instead of centering it.
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(accentColor)
                Spacer()
                // Spacer() pushes the icon to the left and fills the rest
                // of the row with empty space, in case we add something to
                // the right side of this row later.
            }
            Text(value)
                .font(.title2.bold())
                .foregroundColor(Theme.textPrimary)
                // The number is the largest, boldest text on the card since
                // it's the most important piece of information here.
            Text(title)
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
                // Smaller and dimmer than the value, since it's just a label.
            if !subtitle.isEmpty {
                // Only show the subtitle row at all if one was actually
                // provided — some cards (like "Height") don't need one.
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(accentColor)
            }
        }
        .padding()
        // Adds breathing room between the text and the card's edges.
        .frame(maxWidth: .infinity, alignment: .leading)
        // Makes the card stretch to fill whatever width the grid gives it,
        // rather than shrinking to fit its text.
        .cardStyle()
        // Applies the shared background color + rounded corners defined
        // once in Theme.swift, so every card in the app looks consistent.
    }
}

#Preview {
    // "#Preview" is Xcode's live-preview macro — it lets you see this one
    // component rendered in the canvas without running the whole app.
    StatCardView(title: "Current Weight", value: "68 kg", subtitle: "Goal: 74 kg", icon: "scalemass.fill", accentColor: Theme.tertiaryAccent)
        .padding()
        .background(Theme.background)
}
