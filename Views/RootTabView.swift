import SwiftUI

/// The app's root navigation shell — a 5-tab bar that's the very first
/// thing the user sees. Every other screen in the app is reached by
/// either tapping a tab here, or navigating/presenting a sheet from
/// within one of these tabs.
struct RootTabView: View {
    var body: some View {
        TabView {
            // TabView automatically builds the bottom tab bar and switches
            // between its children when the user taps a different tab.

            NavigationStack { DashboardView() }
                .tabItem { Label("Home", systemImage: "house.fill") }
            // Each tab gets its own independent NavigationStack. This
            // matters because it means tapping into a detail screen from
            // the Dashboard tab doesn't affect the navigation state of the
            // other tabs — switching tabs and back preserves exactly where
            // you left off in each one.

            NavigationStack { WorkoutLogView() }
                .tabItem { Label("Workouts", systemImage: "dumbbell.fill") }

            NavigationStack { GoalsView() }
                .tabItem { Label("Goals", systemImage: "target") }

            NavigationStack { ProgressStatsView() }
                .tabItem { Label("Progress", systemImage: "chart.line.uptrend.xyaxis") }

            NavigationStack { ProfileView() }
                .tabItem { Label("Profile", systemImage: "person.fill") }
        }
        .tint(Theme.primaryAccent)
        // Colors the selected tab icon/label (and other system controls
        // like navigation bar buttons) with our brand accent color instead
        // of iOS's default blue.
    }
}
