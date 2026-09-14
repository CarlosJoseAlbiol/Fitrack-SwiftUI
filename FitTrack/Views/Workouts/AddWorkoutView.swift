import SwiftUI

/// SHEET SCREEN
/// A form for logging a new workout, presented modally on top of
/// WorkoutLogView when the user taps the "+" button. Collects an exercise
/// name, category, sets, reps, weight, and duration, then hands the
/// finished WorkoutEntry to the controller to save.
struct AddWorkoutView: View {
    @EnvironmentObject var controller: GymDataController

    @Environment(\.dismiss) private var dismiss
    // A special system value that lets this view close itself — calling
    // "dismiss()" tells SwiftUI to close whichever sheet/screen this view
    // is currently presented as, without needing a reference back to
    // whoever presented it.

    @State private var exerciseName: String = ""
    @State private var category: WorkoutCategory = .push
    @State private var sets: Int = 3
    @State private var reps: Int = 10
    @State private var weight: Double = 20
    @State private var duration: Int = 30
    // Each form field gets its own @State variable, pre-filled with a
    // sensible starting value, so the Stepper controls aren't sitting at
    // zero when the form first opens.

    var body: some View {
        NavigationStack {
            // Wrapped in its own NavigationStack so this sheet can have its
            // own title bar and toolbar buttons, independent of whichever
            // tab presented it.
            Form {
                // "Form" is SwiftUI's built-in container specifically
                // designed for settings/data-entry screens — it automatically
                // gives us the grouped, inset styling seen in apps like
                // Settings, without us building that look by hand.
                Section("Exercise") {
                    TextField("Exercise name", text: $exerciseName)
                    // The "$" prefix creates a two-way binding: as the user
                    // types, "exerciseName" updates live, and if
                    // "exerciseName" were ever changed elsewhere in code,
                    // the text field would update to match.
                    Picker("Category", selection: $category) {
                        ForEach(WorkoutCategory.allCases) { cat in
                            Text(cat.rawValue).tag(cat)
                            // ".tag(cat)" is what tells the Picker which
                            // enum case corresponds to each row, so
                            // selecting "Legs" actually sets category = .legs.
                        }
                    }
                }

                Section("Details") {
                    Stepper("Sets: \(sets)", value: $sets, in: 1...10)
                    Stepper("Reps: \(reps)", value: $reps, in: 1...30)
                    Stepper("Weight: \(weight.formatted(decimals: 0)) kg", value: $weight, in: 0...300, step: 2.5)
                    Stepper("Duration: \(duration) min", value: $duration, in: 5...180, step: 5)
                    // Steppers instead of free-text number fields — this
                    // guarantees the values always stay inside sensible
                    // ranges (e.g. you can't accidentally type "abc" into a
                    // weight field) and keeps data entry to simple taps.
                }
            }
            .navigationTitle("Log Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                    // ".cancellationAction" automatically places this on
                    // the left side of the nav bar, matching the standard
                    // iOS convention for "close without saving."
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let entry = WorkoutEntry(
                            date: Date(),
                            exerciseName: exerciseName.isEmpty ? category.rawValue : exerciseName,
                            // If the user left the name blank, fall back to
                            // the category name (e.g. "Push") instead of
                            // saving a blank, unhelpful title.
                            category: category,
                            sets: sets,
                            reps: reps,
                            weightKg: weight,
                            durationMinutes: duration
                        )
                        controller.addWorkout(entry)
                        // Hands the finished struct to the Controller —
                        // this View never touches the "workouts" array
                        // directly, keeping the MVC separation intact.
                        dismiss()
                        // Closes the sheet immediately after saving.
                    }
                    .disabled(exerciseName.trimmingCharacters(in: .whitespaces).isEmpty)
                    // Greys out the Save button (and makes it untappable)
                    // if the name field is empty or just whitespace,
                    // preventing accidental blank submissions.
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    AddWorkoutView()
        .environmentObject(GymDataController())
}
