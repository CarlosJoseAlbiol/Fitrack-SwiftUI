import Foundation
import SwiftUI

/// CONTROLLER (MVC)
/// This is the "brain" of the app. It owns every piece of data (the user's
/// profile, their goals, their workouts, their nutrition log) and is the
/// *only* place that data is allowed to change. Views never edit a Goal or
/// WorkoutEntry directly — they call a method here instead, like
/// "controller.addWorkout(...)". This keeps the app's logic in one
/// predictable place instead of scattered across every screen.
final class GymDataController: ObservableObject {
    // "final" means no other class can subclass this one — we don't need
    // inheritance here, so this keeps things simple and slightly faster.
    // "ObservableObject" is what makes SwiftUI able to watch this class and
    // automatically redraw any screen that depends on it whenever the data
    // changes underneath it.

    @Published var userProfile: UserProfile
    // "@Published" tells SwiftUI: "whenever this property changes, notify
    // every View that's reading it, so they can refresh." Without this
    // keyword, editing a profile would silently update the data but the
    // screen would never visually update to match.

    @Published var goals: [Goal]
    // The full list of the user's active goals (protein, weight, etc).

    @Published var workouts: [WorkoutEntry]
    // The full history of logged workouts, newest first.

    @Published var nutritionLog: [NutritionEntry]
    // The full history of daily nutrition entries.

    init() {
        // The initializer runs once, when the app first launches, and fills
        // in starter ("seed") data so the app isn't empty on first open —
        // this is what makes the screenshots/demo look populated.
        self.userProfile = GymDataController.sampleProfile()
        self.goals = GymDataController.sampleGoals()
        self.workouts = GymDataController.sampleWorkouts()
        self.nutritionLog = GymDataController.sampleNutrition()
    }

    // MARK: - Workout Management
    // "// MARK:" comments don't affect the code at all — they just create
    // labeled jump-to sections in Xcode's function dropdown at the top of
    // the editor, which keeps a long file easy to navigate.

    func addWorkout(_ workout: WorkoutEntry) {
        // Called by AddWorkoutView's Save button.
        workouts.insert(workout, at: 0)
        // We insert at index 0 (the very front) rather than appending, so
        // the newest workout always shows up first in the log — matching
        // how most fitness apps display a "most recent first" feed.
        syncWorkoutFrequencyGoal()
        // Every time a workout is added, we also recalculate the workout
        // frequency goal so the Goals screen stays accurate automatically.
    }

    func deleteWorkout(at offsets: IndexSet) {
        // "IndexSet" is what SwiftUI's List hands us automatically when
        // the user swipes to delete a row — it tells us exactly which
        // row(s) to remove.
        workouts.remove(atOffsets: offsets)
        syncWorkoutFrequencyGoal()
        // Recalculate again after a deletion, so removing a workout
        // correctly lowers the weekly count shown on the Goals screen.
    }

    var workoutsThisWeek: [WorkoutEntry] {
        // A computed property that filters the full workout list down to
        // just the ones that happened during the current calendar week.
        let calendar = Calendar.current
        return workouts.filter {
            calendar.isDate($0.date, equalTo: Date(), toGranularity: .weekOfYear)
            // "toGranularity: .weekOfYear" checks if two dates fall in the
            // same week, ignoring the exact day/time — exactly what we need
            // for a "workouts this week" count.
        }
    }

    private func syncWorkoutFrequencyGoal() {
        // "private" means only this file can call this method — it's an
        // internal helper, not something a View should ever call directly.
        if let index = goals.firstIndex(where: { $0.type == .workoutFrequency }) {
            // Find where the workout-frequency goal lives in the goals array.
            goals[index].currentValue = Double(workoutsThisWeek.count)
            // Update its "currentValue" to match how many workouts actually
            // happened this week — so the user never has to manually update
            // this goal themselves.
        }
    }

    // MARK: - Goal Management

    func addGoal(_ goal: Goal) {
        // Called by AddGoalView's Save button — simply appends the new
        // goal to the end of the list.
        goals.append(goal)
    }

    func deleteGoal(at offsets: IndexSet) {
        // Same swipe-to-delete pattern as deleteWorkout, kept here in case
        // a future version of GoalsView adds delete support.
        goals.remove(atOffsets: offsets)
    }

    func updateGoalProgress(id: UUID, newValue: Double) {
        // A general-purpose method for manually nudging a goal's progress,
        // available for future features (e.g. a slider to log water intake
        // directly against the Water goal).
        if let index = goals.firstIndex(where: { $0.id == id }) {
            goals[index].currentValue = newValue
        }
    }

    // MARK: - Nutrition Management

    func addNutritionEntry(_ entry: NutritionEntry) {
        nutritionLog.insert(entry, at: 0)
        // Same "newest first" pattern as addWorkout.
        if let index = goals.firstIndex(where: { $0.type == .protein }) {
            goals[index].currentValue = entry.proteinGrams
            // As soon as a new nutrition entry is logged, immediately
            // update the Protein goal to reflect it.
        }
        if let index = goals.firstIndex(where: { $0.type == .calories }) {
            goals[index].currentValue = entry.calories
            // Same idea for the Calories goal.
        }
    }

    var todaysNutrition: NutritionEntry? {
        // Returns today's entry if one exists, or nil if the user hasn't
        // logged anything yet today. The "?" (optional) return type is
        // Swift's way of safely representing "this might not exist."
        nutritionLog.first { Calendar.current.isDateInToday($0.date) }
    }

    // MARK: - Derived Stats
    // These are all read-only values calculated from the raw arrays above —
    // the Dashboard screen pulls from these instead of doing its own math,
    // keeping calculation logic in the Controller where it belongs.

    var totalWorkoutsLogged: Int { workouts.count }
    // Simple count of every workout ever logged, shown on the Dashboard.

    var averageDailyProtein: Double {
        guard !nutritionLog.isEmpty else { return 0 }
        // Avoids a divide-by-zero crash if no nutrition has been logged yet.
        let total = nutritionLog.reduce(0) { $0 + $1.proteinGrams }
        // "reduce" walks through every entry and adds up all the protein
        // values into one running total.
        return total / Double(nutritionLog.count)
        // Dividing the total by the number of entries gives the average.
    }

    // MARK: - Sample / Seed Data
    // Everything below exists purely to give the app realistic-looking
    // starter data on first launch, so it's ready to demo immediately
    // instead of opening to an empty, lifeless screen.

    private static func sampleProfile() -> UserProfile {
        // "static" means this function belongs to the type itself, not to
        // any specific instance — which is required since we're calling it
        // from inside init() before "self" fully exists yet.
        UserProfile(
            name: "Carlos",
            age: 20,
            heightCm: 172,
            currentWeightKg: 68,
            goalWeightKg: 74,
            profileImageName: "person.crop.circle.fill"
        )
    }

    private static func sampleGoals() -> [Goal] {
        [
            Goal(type: .protein, targetValue: 140, currentValue: 96),
            Goal(type: .calories, targetValue: 2600, currentValue: 2100),
            Goal(type: .weight, targetValue: 74, currentValue: 68),
            Goal(type: .workoutFrequency, targetValue: 5, currentValue: 3),
            Goal(type: .water, targetValue: 3, currentValue: 1.8)
        ]
        // One starter goal per GoalType, with believable current-vs-target
        // numbers so the progress bars look meaningfully "in progress"
        // rather than either empty or already complete.
    }

    private static func sampleWorkouts() -> [WorkoutEntry] {
        let cal = Calendar.current
        return [
            WorkoutEntry(date: Date(), exerciseName: "Bench Press", category: .push, sets: 4, reps: 8, weightKg: 60, durationMinutes: 45),
            WorkoutEntry(date: cal.date(byAdding: .day, value: -1, to: Date()) ?? Date(), exerciseName: "Deadlift", category: .pull, sets: 5, reps: 5, weightKg: 90, durationMinutes: 50),
            WorkoutEntry(date: cal.date(byAdding: .day, value: -3, to: Date()) ?? Date(), exerciseName: "Squats", category: .legs, sets: 4, reps: 10, weightKg: 70, durationMinutes: 40),
            WorkoutEntry(date: cal.date(byAdding: .day, value: -5, to: Date()) ?? Date(), exerciseName: "Treadmill Run", category: .cardio, sets: 1, reps: 1, weightKg: 0, durationMinutes: 30)
        ]
        // Four workouts spread across the past several days (today, -1,
        // -3, -5) so the "Weekly Activity" bar chart on the Progress
        // screen has more than one bar to actually show.
        // "?? Date()" is a fallback: if date math somehow fails (it never
        // realistically will here), we default to today instead of crashing.
    }

    private static func sampleNutrition() -> [NutritionEntry] {
        let cal = Calendar.current
        return [
            NutritionEntry(date: Date(), proteinGrams: 96, calories: 2100, waterLiters: 1.8),
            NutritionEntry(date: cal.date(byAdding: .day, value: -1, to: Date()) ?? Date(), proteinGrams: 130, calories: 2400, waterLiters: 2.4),
            NutritionEntry(date: cal.date(byAdding: .day, value: -2, to: Date()) ?? Date(), proteinGrams: 110, calories: 2200, waterLiters: 2.0)
        ]
        // Three days of nutrition history, giving the "Nutrition Trend"
        // line chart on the Progress screen more than a single data point.
    }
}
