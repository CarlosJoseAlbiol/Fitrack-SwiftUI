import SwiftUI

/// SHEET SCREEN
/// A form for editing the user's name, age, height, weight, and goal
/// weight. Presented modally from ProfileView's "Edit Profile" button.
struct EditProfileView: View {
    @EnvironmentObject var controller: GymDataController
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var age: Int = 20
    @State private var height: Double = 170
    @State private var weight: Double = 70
    @State private var goalWeight: Double = 75
    // These start as generic placeholder defaults, but they're immediately
    // overwritten with the user's real current data in .onAppear below —
    // the values here just exist so the @State properties have *something*
    // to hold before that happens.

    var body: some View {
        NavigationStack {
            Form {
                Section("About") {
                    TextField("Name", text: $name)
                    Stepper("Age: \(age)", value: $age, in: 13...90)
                }
                Section("Body Stats") {
                    Stepper("Height: \(height.formatted(decimals: 0)) cm", value: $height, in: 100...250)
                    Stepper("Current Weight: \(weight.formatted(decimals: 0)) kg", value: $weight, in: 30...250)
                    Stepper("Goal Weight: \(goalWeight.formatted(decimals: 0)) kg", value: $goalWeight, in: 30...250)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                    // Because we edit local @State copies (not the real
                    // profile directly) and only write back on Save,
                    // hitting Cancel here safely discards any changes the
                    // user made — the real userProfile is untouched.
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        controller.userProfile.name = name
                        controller.userProfile.age = age
                        controller.userProfile.heightCm = height
                        controller.userProfile.currentWeightKg = weight
                        controller.userProfile.goalWeightKg = goalWeight
                        // Only now, when Save is actually tapped, do we
                        // copy every local field back onto the real,
                        // shared userProfile — which instantly updates the
                        // Dashboard and Profile screens too, since they're
                        // both watching the same @Published property.
                        dismiss()
                    }
                }
            }
            .onAppear {
                // Runs once, right when this sheet appears on screen.
                name = controller.userProfile.name
                age = controller.userProfile.age
                height = controller.userProfile.heightCm
                weight = controller.userProfile.currentWeightKg
                goalWeight = controller.userProfile.goalWeightKg
                // Copies the user's *actual current* profile data into our
                // local @State fields, so the form opens pre-filled with
                // their real info instead of the generic placeholder
                // defaults declared above.
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    EditProfileView()
        .environmentObject(GymDataController())
}
