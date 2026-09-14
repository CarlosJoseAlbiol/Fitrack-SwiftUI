import SwiftUI

/// SHEET SCREEN
/// A form for creating a brand-new goal, presented modally from GoalsView.
/// The user picks a goal type, then sets a target and starting value.
struct AddGoalView: View {
    @EnvironmentObject var controller: GymDataController
    @Environment(\.dismiss) private var dismiss

    @State private var type: GoalType = .protein
    @State private var target: Double = 100
    @State private var current: Double = 0
    // Sensible defaults so the form isn't sitting at zero/blank when it
    // first opens — protein is picked as the default type since it's the
    // most commonly tracked goal in a gym app.

    var body: some View {
        NavigationStack {
            Form {
                Section("Goal Type") {
                    Picker("Type", selection: $type) {
                        ForEach(GoalType.allCases) { t in
                            Text(t.rawValue).tag(t)
                        }
                    }
                    // Same Picker + allCases pattern used in AddWorkoutView,
                    // guaranteeing the user can only pick one of the five
                    // valid GoalType cases — never a typo'd custom category.
                }
                Section("Target") {
                    Stepper("Target: \(target.formatted(decimals: 0)) \(type.unit)", value: $target, in: 1...5000, step: 5)
                    Stepper("Current: \(current.formatted(decimals: 0)) \(type.unit)", value: $current, in: 0...5000, step: 5)
                    // Notice both labels use "\(type.unit)" — since "type"
                    // is a @State variable, the moment the user changes the
                    // picker (say, from Protein to Water), these labels
                    // instantly relabel themselves from "g" to "L" with no
                    // extra code needed.
                }
            }
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        controller.addGoal(Goal(type: type, targetValue: target, currentValue: current))
                        dismiss()
                    }
                    // Unlike AddWorkoutView's Save button, this one has no
                    // ".disabled(...)" condition — every combination of
                    // type/target/current here is always valid, so there's
                    // nothing that needs to block submission.
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    AddGoalView()
        .environmentObject(GymDataController())
}
