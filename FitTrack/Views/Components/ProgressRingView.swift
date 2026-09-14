import SwiftUI

/// REUSABLE COMPONENT (View)
/// Draws a circular progress ring (like Apple's Activity rings) with a
/// number in the center. Used twice on the Dashboard: one ring for the
/// protein goal, one for the weekly workout goal.
struct ProgressRingView: View {
    let progress: Double
    // A fraction from 0.0 (empty) to 1.0 (completely full).

    let color: Color
    // The ring's color — lets us reuse this same shape for both the orange
    // protein ring and the green workout ring.

    var lineWidth: CGFloat = 12
    // How thick the ring's stroke is. Given a default value, so callers
    // don't have to specify it unless they want something different.

    var size: CGFloat = 120
    // The width/height of the ring in points.

    var label: String = ""
    // The big text in the center, e.g. "96g".

    var sublabel: String = ""
    // Smaller text under the label, e.g. "Protein".

    var body: some View {
        ZStack {
            // ZStack layers its children on top of each other instead of
            // side-by-side — exactly what we need to draw a ring, then
            // another ring on top of it, then text in the center.

            Circle()
                .stroke(color.opacity(0.15), lineWidth: lineWidth)
                // This is the "track" — a faint, full circle that represents
                // 100%, drawn first so it sits behind everything else.

            Circle()
                .trim(from: 0, to: min(max(progress, 0), 1))
                // ".trim" draws only part of the circle's outline instead of
                // the whole thing — from 0% up to our current progress.
                // "min(max(progress, 0), 1)" is a safety clamp: no matter
                // what value gets passed in, it's forced to stay between 0
                // and 1, so a bug elsewhere can't draw a broken/negative ring.
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                // ".round" gives the ring soft, rounded ends instead of a
                // hard flat cut-off, which looks noticeably more polished.
                .rotationEffect(.degrees(-90))
                // Circles are drawn starting at the 3 o'clock position by
                // default; rotating -90 degrees makes it start at the top
                // (12 o'clock) instead, which matches how progress rings
                // are usually expected to look.
                .animation(.easeOut(duration: 0.6), value: progress)
                // Automatically animates the ring filling up smoothly any
                // time "progress" changes, instead of jumping instantly.

            VStack(spacing: 2) {
                Text(label)
                    .font(.title3.bold())
                    .foregroundColor(Theme.textPrimary)
                if !sublabel.isEmpty {
                    Text(sublabel)
                        .font(.caption2)
                        .foregroundColor(Theme.textSecondary)
                }
            }
            // The center text sits on top of both circles since it's the
            // last thing added to the ZStack.
        }
        .frame(width: size, height: size)
        // Locks the whole ring to a fixed square size.
    }
}

#Preview {
    ProgressRingView(progress: 0.68, color: Theme.primaryAccent, label: "96g", sublabel: "Protein")
        .padding()
        .background(Theme.background)
}
