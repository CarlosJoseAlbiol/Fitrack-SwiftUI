import SwiftUI

/// REUSABLE COMPONENT (View)
/// A card representing one goal: its icon and name, a percentage, a
/// progress bar, and the current/target numbers underneath. This is what
/// GoalsView displays once per goal in the user's list.
struct GoalRowView: View {
    let goal: Goal
    // The single Goal this card is built from.

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: goal.type.icon)
                    .foregroundColor(Theme.primaryAccent)
                Text(goal.type.rawValue)
                    .font(.subheadline.bold())
                    .foregroundColor(Theme.textPrimary)
                // ".rawValue" pulls the plain text version straight from
                // the enum, e.g. GoalType.protein.rawValue == "Protein".
                Spacer()
                Text(goal.progressPercentText)
                    .font(.caption.bold())
                    .foregroundColor(Theme.secondaryAccent)
                // Shows the percentage computed back in the Goal model,
                // e.g. "68%" — the View never does this math itself.
            }

            ProgressView(value: goal.progress)
                .tint(Theme.primaryAccent)
                // SwiftUI's built-in linear progress bar. We just feed it
                // the 0–1 "progress" value the Goal model already calculated.

            HStack {
                Text("\(goal.currentValue.formatted(decimals: 0)) \(goal.type.unit)")
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
                Spacer()
                Text("Target: \(goal.targetValue.formatted(decimals: 0)) \(goal.type.unit)")
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
                // Shows the raw numbers on either end of the row (current
                // on the left, target on the right), so the percentage and
                // progress bar above have concrete numbers to back them up.
            }
        }
        .padding()
        .cardStyle()
    }
}

#Preview {
    GoalRowView(goal: Goal(type: .protein, targetValue: 140, currentValue: 96))
        .padding()
        .background(Theme.background)
}
