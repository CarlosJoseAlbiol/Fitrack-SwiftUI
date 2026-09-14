import SwiftUI
import Charts
// "Charts" is Apple's built-in framework (iOS 16+) for drawing bar/line/
// area charts declaratively, the same way SwiftUI builds regular views.
// No third-party library needed.

/// SCREEN 4: Progress
/// Visual overview of the user's activity: a bar chart of workouts per day
/// this week, a line chart of protein intake over time, and a short list
/// of their heaviest lifts (personal records).
struct ProgressStatsView: View {
    @EnvironmentObject var controller: GymDataController

    private var weeklyWorkoutCounts: [(day: String, count: Int)] {
        // Builds the exact data the bar chart needs: one (day, count) pair
        // per day of the past week. We compute this here in the View
        // rather than the Controller because it's purely about *how this
        // one chart wants its data shaped* — a formatting concern, not a
        // core piece of app data.
        let calendar = Calendar.current
        let today = Date()
        return (0..<7).reversed().map { offset in
            // "0..<7" gives us 0,1,2...6; ".reversed()" flips it to
            // 6,5,4...0 so when we subtract each offset from today, the
            // resulting dates come out oldest-to-newest (6 days ago first,
            // today last) — which is the order a chart should read left-to-right.
            let date = calendar.date(byAdding: .day, value: -offset, to: today) ?? today
            let count = controller.workouts.filter { calendar.isDate($0.date, inSameDayAs: date) }.count
            // Counts how many logged workouts fall on that exact day.
            return (day: date.weekdayDisplay, count: count)
            // Returns a tuple pairing the weekday label (e.g. "Mon") with
            // its workout count, ready for the Chart below to consume.
        }
    }

    private var topLifts: [WorkoutEntry] {
        Array(controller.workouts.sorted { $0.weightKg > $1.weightKg }.prefix(3))
        // Sorts every workout heaviest-first, then keeps only the top 3 —
        // a simple, readable way to surface "personal records" without
        // needing a dedicated PR-tracking system yet.
    }

    var body: some View {
        ZStack {
            Theme.backgroundGradient.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    sectionHeader("Weekly Activity")

                    Chart(weeklyWorkoutCounts, id: \.day) { item in
                        // "id: \.day" tells Chart how to uniquely identify
                        // each data point, since our tuple isn't Identifiable
                        // the way our model structs are.
                        BarMark(
                            x: .value("Day", item.day),
                            y: .value("Workouts", item.count)
                        )
                        // One bar per weekday, height determined by that
                        // day's workout count.
                        .foregroundStyle(Theme.primaryAccent.gradient)
                        // ".gradient" automatically creates a subtle
                        // top-to-bottom fade from our flat accent color,
                        // rather than us building a custom gradient by hand.
                        .cornerRadius(6)
                        // Slightly rounds the top of each bar for a softer look.
                    }
                    .frame(height: 200)
                    .padding()
                    .cardStyle()
                    .padding(.horizontal)
                    // The whole chart is wrapped in the same card style
                    // used everywhere else, so it feels consistent with
                    // stat cards and goal cards rather than looking like a
                    // separate, bare chart floating on the background.

                    sectionHeader("Nutrition Trend")

                    Chart(controller.nutritionLog.reversed()) { entry in
                        // ".reversed()" because nutritionLog is stored
                        // newest-first (for the "recent" list use case),
                        // but a trend line needs to read left-to-right in
                        // chronological order, so we flip it just for this chart.
                        LineMark(
                            x: .value("Date", entry.date, unit: .day),
                            y: .value("Protein", entry.proteinGrams)
                        )
                        .foregroundStyle(Theme.secondaryAccent)
                        .interpolationMethod(.catmullRom)
                        // Smooths the line into gentle curves between points
                        // instead of sharp straight-line segments.
                        .symbol(Circle())
                        // Draws a small circle marker at each actual data
                        // point along the line, so individual days are
                        // still identifiable even on the smoothed curve.
                    }
                    .frame(height: 200)
                    .padding()
                    .cardStyle()
                    .padding(.horizontal)

                    sectionHeader("Personal Records")

                    VStack(spacing: 10) {
                        ForEach(topLifts) { workout in
                            WorkoutRowView(workout: workout)
                            // Reuses the exact same row component from the
                            // Workout Log screen — no need to build a
                            // separate "PR row" layout from scratch.
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
        .navigationTitle("Progress")
    }

    private func sectionHeader(_ title: String) -> some View {
        // A tiny helper function (not a computed property this time, since
        // it needs a parameter) that keeps the three section titles above
        // visually identical without repeating the same three modifier
        // lines three separate times.
        Text(title)
            .font(.headline)
            .foregroundColor(Theme.textPrimary)
            .padding(.horizontal)
    }
}

#Preview {
    NavigationStack { ProgressStatsView() }
        .environmentObject(GymDataController())
        .preferredColorScheme(.dark)
}
