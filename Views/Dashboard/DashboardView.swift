import SwiftUI

/// SCREEN 1: Dashboard / Home
/// The app's landing screen — a quick overview so the user doesn't have to
/// dig through other tabs just to see how their day/week is going. Shows a
/// greeting, two progress rings, four quick-stat cards, and a preview of
/// the most recent workouts.
struct DashboardView: View {
    @EnvironmentObject var controller: GymDataController
    // Pulls in the shared data controller that was injected back in
    // FitTrackApp.swift, giving this screen read/write access to every
    // piece of app data without it being passed in manually.

    private var proteinGoal: Goal? {
        controller.goals.first { $0.type == .protein }
    }
    // Searches the goals array for the one goal of type .protein.
    // It's optional ("Goal?") because, in theory, that goal might not
    // exist (e.g. if it were deleted) — the "?" forces every use of this
    // property to handle that possibility safely instead of crashing.

    private var workoutGoal: Goal? {
        controller.goals.first { $0.type == .workoutFrequency }
    }
    // Same idea, but for the workout-frequency goal.

    var body: some View {
        ZStack {
            Theme.backgroundGradient.ignoresSafeArea()
            // The dark gradient backdrop, extended under the status bar and
            // home indicator with ".ignoresSafeArea()" so there's no
            // visible seam at the edges of the screen.

            ScrollView {
                // Wraps everything in a scroll view since the combined
                // content (rings + stat grid + recent workouts) is taller
                // than most screens.
                VStack(alignment: .leading, spacing: 24) {
                    header

                    HStack(spacing: 16) {
                        Spacer()
                        ProgressRingView(
                            progress: proteinGoal?.progress ?? 0,
                            // "?? 0" means: if proteinGoal is nil, just show
                            // an empty (0%) ring instead of crashing.
                            color: Theme.primaryAccent,
                            label: "\(Int(proteinGoal?.currentValue ?? 0))g",
                            sublabel: "Protein"
                        )
                        Spacer()
                        ProgressRingView(
                            progress: workoutGoal?.progress ?? 0,
                            color: Theme.secondaryAccent,
                            label: "\(Int(workoutGoal?.currentValue ?? 0))/\(Int(workoutGoal?.targetValue ?? 1))",
                            sublabel: "Workouts"
                        )
                        Spacer()
                    }
                    // Two rings placed side-by-side with Spacers evenly
                    // splitting the leftover horizontal space between and
                    // around them, so they stay centered as a pair.

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                        // A 2-column grid. "LazyVGrid" only builds the cards
                        // that are actually visible on screen at any given
                        // moment, which keeps scrolling smooth even if this
                        // grid grew much longer in a future version.
                        StatCardView(title: "Current Weight", value: "\(controller.userProfile.currentWeightKg.formatted(decimals: 0)) kg", subtitle: "Goal: \(controller.userProfile.goalWeightKg.formatted(decimals: 0)) kg", icon: "scalemass.fill", accentColor: Theme.tertiaryAccent)
                        StatCardView(title: "Workouts Logged", value: "\(controller.totalWorkoutsLogged)", subtitle: "All time", icon: "dumbbell.fill", accentColor: Theme.primaryAccent)
                        StatCardView(title: "Avg. Protein", value: "\(controller.averageDailyProtein.formatted(decimals: 0))g", subtitle: "Daily average", icon: "fork.knife", accentColor: Theme.secondaryAccent)
                        StatCardView(title: "BMI", value: controller.userProfile.bmi.formatted(decimals: 1), subtitle: controller.userProfile.bmiCategory, icon: "heart.text.square.fill", accentColor: Theme.tertiaryAccent)
                        // Four cards, each reusing the same StatCardView
                        // component but fed different data/colors — this is
                        // the payoff of building a reusable component
                        // instead of writing four near-identical layouts.
                    }
                    .padding(.horizontal)

                    recentWorkoutsSection
                }
                .padding(.bottom, 30)
                // Extra bottom padding so the last card isn't flush against
                // the very bottom edge of the scroll view.
            }
        }
        .navigationTitle("Dashboard")
        .navigationBarTitleDisplayMode(.inline)
        // Keeps the "Dashboard" title small and centered in the nav bar
        // instead of the large, left-aligned iOS default title style.
    }

    private var header: some View {
        // Broken out into its own computed property purely to keep "body"
        // shorter and easier to read — this is standard practice once a
        // SwiftUI view starts getting long.
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome back,")
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
                Text(controller.userProfile.name)
                    .font(.title.bold())
                    .foregroundColor(Theme.textPrimary)
            }
            Spacer()
            Image(systemName: controller.userProfile.profileImageName)
                .font(.system(size: 40))
                .foregroundColor(Theme.primaryAccent)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    private var recentWorkoutsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Workouts")
                    .font(.headline)
                    .foregroundColor(Theme.textPrimary)
                Spacer()
                NavigationLink("See All") { WorkoutLogView() }
                    .font(.caption.bold())
                    .foregroundColor(Theme.primaryAccent)
                // NavigationLink is what actually performs the navigation:
                // tapping "See All" pushes WorkoutLogView onto this tab's
                // NavigationStack, giving the user a real "drill-down" flow
                // straight from the Dashboard.
            }
            .padding(.horizontal)

            VStack(spacing: 10) {
                ForEach(controller.workouts.prefix(3)) { workout in
                    WorkoutRowView(workout: workout)
                }
                // ".prefix(3)" only takes the first three workouts (the
                // three most recent, since new ones are always inserted at
                // the front of the array) — this screen is meant to be a
                // quick preview, not the full list.
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    NavigationStack { DashboardView() }
        .environmentObject(GymDataController())
        // The preview needs its own controller instance since it's not
        // running inside the real app where FitTrackApp normally provides one.
        .preferredColorScheme(.dark)
}
