import SwiftUI

/// SCREEN 5: Profile
/// Shows the user's body-stat summary (avatar, name, age, height, weight,
/// BMI, goal weight) and an "Edit Profile" button that opens a form to
/// update any of that information.
struct ProfileView: View {
    @EnvironmentObject var controller: GymDataController

    @State private var isEditing = false
    // Tracks whether the Edit Profile sheet is open — same pattern used
    // for every other "+"/edit sheet in the app.

    var body: some View {
        ZStack {
            Theme.backgroundGradient.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 10) {
                        Image(systemName: controller.userProfile.profileImageName)
                            .font(.system(size: 70))
                            .foregroundColor(Theme.primaryAccent)
                        Text(controller.userProfile.name)
                            .font(.title2.bold())
                            .foregroundColor(Theme.textPrimary)
                        Text("Age \(controller.userProfile.age)")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                    }
                    .padding(.top, 20)
                    // A simple centered "avatar card": icon, name, age —
                    // acts as the header for the rest of the screen.

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                        StatCardView(title: "Height", value: "\(controller.userProfile.heightCm.formatted(decimals: 0)) cm", subtitle: "", icon: "ruler.fill", accentColor: Theme.tertiaryAccent)
                        StatCardView(title: "Weight", value: "\(controller.userProfile.currentWeightKg.formatted(decimals: 0)) kg", subtitle: "", icon: "scalemass.fill", accentColor: Theme.primaryAccent)
                        StatCardView(title: "BMI", value: controller.userProfile.bmi.formatted(decimals: 1), subtitle: controller.userProfile.bmiCategory, icon: "heart.text.square.fill", accentColor: Theme.secondaryAccent)
                        StatCardView(title: "Goal Weight", value: "\(controller.userProfile.goalWeightKg.formatted(decimals: 0)) kg", subtitle: "", icon: "target", accentColor: Theme.tertiaryAccent)
                        // Same StatCardView component from the Dashboard,
                        // reused again here with profile-specific data —
                        // this is the second of three places it's used.
                    }
                    .padding(.horizontal)

                    Button {
                        isEditing = true
                    } label: {
                        Text("Edit Profile")
                            .font(.subheadline.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.cardGradient)
                            .cornerRadius(Theme.cornerRadius)
                    }
                    .padding(.horizontal)
                    // A full-width call-to-action button using the app's
                    // gradient accent, styled by hand here rather than
                    // through .cardStyle() since it needs the colored
                    // gradient background instead of the neutral card color.
                }
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Profile")
        .sheet(isPresented: $isEditing) {
            EditProfileView()
        }
    }
}

#Preview {
    NavigationStack { ProfileView() }
        .environmentObject(GymDataController())
        .preferredColorScheme(.dark)
}
