import SwiftUI

/// SCREEN 3: Goals
/// Lists every active goal (protein, calories, weight, workout frequency,
/// water) as a progress card. A "+" button opens a form to add a new one.
struct GoalsView: View {
    @EnvironmentObject var controller: GymDataController

    @State private var showingAddGoal = false
    // Tracks whether the Add Goal sheet is currently open, same pattern
    // as "showingAddWorkout" on the Workout Log screen.

    var body: some View {
        ZStack {
            Theme.backgroundGradient.ignoresSafeArea()

            ScrollView {
                LazyVStack(spacing: 14) {
                    // "LazyVStack" instead of a plain VStack because this
                    // list could grow as the user adds more goals — Lazy
                    // versions only render what's currently on screen,
                    // which keeps things smooth even with many goals.
                    ForEach(controller.goals) { goal in
                        GoalRowView(goal: goal)
                        // Every goal in the controller's array becomes one
                        // GoalRowView card — add a goal via the sheet below
                        // and a new card appears here automatically, since
                        // this View is watching @Published var goals.
                    }
                }
                .padding()
            }
        }
        .navigationTitle("My Goals")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddGoal = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Theme.primaryAccent)
                }
            }
        }
        .sheet(isPresented: $showingAddGoal) {
            AddGoalView()
        }
    }
}

#Preview {
    NavigationStack { GoalsView() }
        .environmentObject(GymDataController())
        .preferredColorScheme(.dark)
}
