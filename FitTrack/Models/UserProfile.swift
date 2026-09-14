import Foundation
// Foundation gives us basic types like UUID and Double math — we need it
// even though this file has no UI code.

/// MODEL (MVC)
/// This struct represents the person using the app: their basic info and
/// body measurements. It has no logic about *how* it's displayed — that's
/// the View's job. It only knows how to hold and calculate data about itself.
struct UserProfile: Identifiable, Codable {
    // Identifiable lets SwiftUI tell one UserProfile apart from another
    // (needed any time a struct is used in a List or ForEach).
    // Codable means this struct can later be saved to disk or sent over
    // the network as JSON, without extra work — useful for a future feature
    // like saving progress between app launches.

    var id = UUID()
    // A unique ID generated automatically every time a UserProfile is made.
    // We never set this ourselves; it's just there so SwiftUI can track it.

    var name: String
    // The user's display name, shown on the Dashboard and Profile screens.

    var age: Int
    // The user's age in years.

    var heightCm: Double
    // Height in centimeters. Stored as Double (not Int) because BMI math
    // needs decimal precision.

    var currentWeightKg: Double
    // The user's current body weight in kilograms.

    var goalWeightKg: Double
    // The weight the user is aiming for — used to show progress toward a goal.

    var profileImageName: String
    // The name of an SF Symbol (Apple's built-in icon set) used as a stand-in
    // profile picture, e.g. "person.crop.circle.fill".

    var bmi: Double {
        // A "computed property" — instead of storing BMI, we calculate it
        // fresh every time it's asked for, so it's always accurate even
        // after the user edits their weight or height.
        let heightM = heightCm / 100
        // BMI formula needs height in meters, but we store centimeters,
        // so we convert here.
        guard heightM > 0 else { return 0 }
        // Safety check: if height is somehow zero, we return 0 instead of
        // crashing the app with a divide-by-zero error.
        return currentWeightKg / (heightM * heightM)
        // Standard BMI formula: weight (kg) divided by height (m) squared.
    }

    var bmiCategory: String {
        // Converts the raw BMI number into a human-readable category,
        // matching the standard WHO BMI classification ranges.
        switch bmi {
        case ..<18.5: return "Underweight"
        // Anything below 18.5.
        case 18.5..<25: return "Normal"
        // The healthy range.
        case 25..<30: return "Overweight"
        // Above normal but below obese.
        default: return "Obese"
        // Everything 30 and above falls here.
        }
    }
}
