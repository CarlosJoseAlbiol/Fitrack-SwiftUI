import SwiftUI

/// REUSABLE COMPONENT (View)
/// A single horizontal row representing one logged workout: a category
/// icon, the exercise name and details, and the date/duration on the
/// right. Reused in three places: the Dashboard's "Recent Workouts"
/// preview, the full Workout Log list, and the Progress screen's
/// "Personal Records" section.
struct WorkoutRowView: View {
    let workout: WorkoutEntry
    // The one piece of data this row needs — everything it displays is
    // read directly from this single WorkoutEntry.

    var body: some View {
        HStack(spacing: 14) {
            // HStack lays its children out left-to-right, with 14 points
            // of space between each one.

            ZStack {
                Circle()
                    .fill(Theme.primaryAccent.opacity(0.15))
                    .frame(width: 44, height: 44)
                // A soft, translucent circular badge behind the icon —
                // this is a common iOS pattern for making small icons feel
                // more substantial and tappable-looking.
                Image(systemName: workout.category.icon)
                    .foregroundColor(Theme.primaryAccent)
                // The icon itself is pulled straight from the workout's
                // category (Push/Pull/Legs/Cardio/Core), defined back in
                // the WorkoutCategory enum.
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(workout.exerciseName)
                    .font(.subheadline.bold())
                    .foregroundColor(Theme.textPrimary)
                Text("\(workout.sets) sets x \(workout.reps) reps · \(workout.weightKg.formatted(decimals: 0))kg")
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
                // One combined line summarizing the sets, reps, and weight,
                // instead of three separate lines — keeps each row compact.
            }

            Spacer()
            // Pushes the date/duration block all the way to the right edge.

            VStack(alignment: .trailing, spacing: 3) {
                Text(workout.date.shortDisplay)
                    .font(.caption.bold())
                    .foregroundColor(Theme.textSecondary)
                Text("\(workout.durationMinutes) min")
                    .font(.caption2)
                    .foregroundColor(Theme.secondaryAccent)
            }
        }
        .padding()
        .cardStyle()
        // Same shared card background/rounding as every other card in the
        // app, so workout rows visually match stat cards and goal cards.
    }
}

#Preview {
    WorkoutRowView(workout: WorkoutEntry(date: Date(), exerciseName: "Bench Press", category: .push, sets: 4, reps: 8, weightKg: 60, durationMinutes: 45))
        .padding()
        .background(Theme.background)
}
