import Foundation

/// MODEL (MVC)
/// Defines the *kinds* of goals a user can track. Using an enum here (instead
/// of letting the user type free text) guarantees every goal in the app is
/// one of these five known categories — no typos, no inconsistent naming.
enum GoalType: String, CaseIterable, Codable, Identifiable {
    // String: each case has a matching text value (e.g. .protein = "Protein"),
    //   which is what gets displayed directly in pickers and labels.
    // CaseIterable: lets us write "GoalType.allCases" to loop through every
    //   case automatically — used in the Add Goal picker.
    // Codable: so goals can be saved/loaded later.
    // Identifiable: required for SwiftUI's ForEach/Picker to track each case.

    case protein = "Protein"
    case calories = "Calories"
    case weight = "Weight"
    case workoutFrequency = "Workout Frequency"
    case water = "Water Intake"
    // The five goal categories this version of the app supports.

    var id: String { rawValue }
    // Identifiable requires an "id" — we just reuse the case's own text
    // value since it's already unique.

    var unit: String {
        // Returns the correct measurement unit for each goal type, so the
        // UI can show "140 g" for protein but "3 L" for water, automatically.
        switch self {
        case .protein: return "g"
        case .calories: return "kcal"
        case .weight: return "kg"
        case .workoutFrequency: return "sessions/wk"
        case .water: return "L"
        }
    }

    var icon: String {
        // Returns an SF Symbol name that visually represents this goal type,
        // used in GoalRowView so each goal has a matching icon.
        switch self {
        case .protein: return "fork.knife"
        case .calories: return "flame.fill"
        case .weight: return "scalemass.fill"
        case .workoutFrequency: return "figure.strengthtraining.traditional"
        case .water: return "drop.fill"
        }
    }
}

/// MODEL (MVC)
/// Represents one specific goal the user is tracking — e.g. "Protein: 96g
/// out of a 140g target." This is the data that GoalRowView displays.
struct Goal: Identifiable, Codable {
    var id = UUID()
    // Unique identifier so SwiftUI can tell multiple goals apart in a list.

    var type: GoalType
    // Which kind of goal this is (protein, weight, etc.) — reuses the enum above.

    var targetValue: Double
    // The number the user is trying to reach (e.g. 140 grams of protein).

    var currentValue: Double
    // The number the user is currently at (e.g. 96 grams so far today).

    var progress: Double {
        // Converts the two raw numbers above into a 0.0–1.0 fraction, which
        // is exactly what SwiftUI's built-in ProgressView expects.
        guard targetValue > 0 else { return 0 }
        // Prevents a crash if a target is ever accidentally set to 0.
        return min(currentValue / targetValue, 1.0)
        // We cap it at 1.0 (100%) so the progress bar never overflows past
        // full, even if the user exceeds their goal.
    }

    var progressPercentText: String {
        // Turns the 0.0–1.0 fraction into a whole-number percentage string
        // like "68%" for display next to the progress bar.
        "\(Int(progress * 100))%"
    }
}
