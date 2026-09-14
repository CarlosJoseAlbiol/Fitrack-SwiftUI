import SwiftUI

/// SCREEN 2: Workout Log
/// The full, scrollable history of every workout the user has logged.
/// Supports swipe-to-delete and a "+" button that opens the Add Workout
/// form as a sheet.
struct WorkoutLogView: View {
    @EnvironmentObject var controller: GymDataController

    @State private var showingAddWorkout = false
    // "@State" is for simple, view-local values that don't need to be
    // shared anywhere else. This one just tracks whether the Add Workout
    // sheet is currently open or closed.

    var body: some View {
        ZStack {
            Theme.backgroundGradient.ignoresSafeArea()

            if controller.workouts.isEmpty {
                emptyState
                // If there's genuinely nothing logged yet, show a friendly
                // placeholder instead of a blank, confusing screen.
            } else {
                List {
                    // We specifically use "List" here (instead of ScrollView
                    // + VStack like the other screens) because List is what
                    // gives us built-in, native swipe-to-delete gestures —
                    // ScrollView doesn't support that out of the box.
                    ForEach(controller.workouts) { workout in
                        WorkoutRowView(workout: workout)
                            .listRowBackground(Color.clear)
                            // Removes List's default white/gray row
                            // background so our custom dark card style
                            // (from .cardStyle()) shows through instead.
                            .listRowSeparator(.hidden)
                            // Hides the thin default divider line between
                            // rows, since our cards already have their own
                            // visual separation via spacing and background.
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            // Controls the exact spacing around each row so
                            // cards have consistent breathing room on every
                            // side, matching the padding used elsewhere.
                    }
                    .onDelete(perform: controller.deleteWorkout)
                    // This one line is what enables swipe-to-delete. List
                    // automatically shows a red delete button when the user
                    // swipes a row left, and calls this function with the
                    // index of whichever row was swiped.
                }
                .listStyle(.plain)
                // Removes the grouped/sectioned List styling in favor of a
                // plain, borderless list that blends into our custom design.
                .scrollContentBackground(.hidden)
                // Hides List's own default background entirely so our
                // Theme.backgroundGradient (drawn behind it in the ZStack)
                // is what actually shows through.
            }
        }
        .navigationTitle("Workout Log")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddWorkout = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Theme.primaryAccent)
                }
            }
            // Adds a "+" button to the top-right of the navigation bar,
            // matching the standard iOS pattern for "add new item."
        }
        .sheet(isPresented: $showingAddWorkout) {
            AddWorkoutView()
        }
        // ".sheet" presents AddWorkoutView as a modal card sliding up from
        // the bottom, and automatically dismisses it whenever
        // "showingAddWorkout" is set back to false (which AddWorkoutView
        // does itself after saving or canceling).
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "dumbbell")
                .font(.system(size: 50))
                .foregroundColor(Theme.textSecondary)
            Text("No workouts logged yet")
                .foregroundColor(Theme.textSecondary)
            Text("Tap + to add your first workout")
                .font(.caption)
                .foregroundColor(Theme.textSecondary)
        }
    }
}

#Preview {
    NavigationStack { WorkoutLogView() }
        .environmentObject(GymDataController())
        .preferredColorScheme(.dark)
}
