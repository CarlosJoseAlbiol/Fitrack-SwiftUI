import Foundation

/// MODEL (MVC)
/// Represents one day's worth of nutrition tracking. This is a simpler
/// model than WorkoutEntry — it just holds three numbers per day — but it
/// still follows the same idea: pure data, no UI or logic about display.
struct NutritionEntry: Identifiable, Codable {
    var id = UUID()
    // Unique id, same purpose as in the other models.

    var date: Date
    // The day this nutrition log applies to.

    var proteinGrams: Double
    // Grams of protein consumed that day — this feeds the Protein goal's
    // "currentValue" whenever a new entry is added.

    var calories: Double
    // Total calories consumed that day — feeds the Calories goal.

    var waterLiters: Double
    // Liters of water consumed that day — feeds the Water Intake goal.
}
