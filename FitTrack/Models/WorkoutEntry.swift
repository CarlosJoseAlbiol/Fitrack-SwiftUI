import Foundation

/// MODEL (MVC)
/// The muscle-group / training category a workout belongs to. Like GoalType,
/// this is an enum so every workout is tagged consistently instead of the
/// user typing free-form categories.
enum WorkoutCategory: String, CaseIterable, Codable, Identifiable {
    case push = "Push"
    case pull = "Pull"
    case legs = "Legs"
    case cardio = "Cardio"
    case core = "Core"
    // The five training categories this version of the app supports.

    var id: String { rawValue }
    // Reuses the case's text as its unique id, same reasoning as GoalType.

    var icon: String {
        // Each category gets its own SF Symbol so workout rows are easy to
        // scan visually (e.g. a running figure for Cardio).
        switch self {
        case .push: return "figure.strengthtraining.traditional"
        case .pull: return "figure.climbing"
        case .legs: return "figure.run"
        case .cardio: return "heart.fill"
        case .core: return "figure.core.training"
        }
    }
}

/// MODEL (MVC)
/// Represents one logged exercise — e.g. "Bench Press, 4 sets of 8 reps at
/// 60kg." Every entry the user saves in the Workout Log is one of these.
struct WorkoutEntry: Identifiable, Codable {
    var id = UUID()
    // Unique id so the list can tell each workout apart and support
    // swipe-to-delete on the correct row.

    var date: Date
    // When the workout happened. Used to sort recent workouts and to build
    // the weekly activity chart on the Progress screen.

    var exerciseName: String
    // The name of the exercise, e.g. "Bench Press" or "Deadlift."

    var category: WorkoutCategory
    // Which training category this exercise falls under (push/pull/legs/etc).

    var sets: Int
    // How many sets were performed.

    var reps: Int
    // How many reps were performed per set.

    var weightKg: Double
    // How much weight was used, in kilograms. 0 for bodyweight/cardio work.

    var durationMinutes: Int
    // How long the exercise/session took, in minutes.
}
