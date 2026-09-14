import Foundation

extension Date {
    // Small helpers that turn a raw Date into the exact text format each
    // screen needs, so views stay clean instead of formatting dates inline.

    var shortDisplay: String {
        // Formats a date like "Sep 4" — used on workout rows so recent
        // activity is easy to scan at a glance.
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: self)
    }

    var weekdayDisplay: String {
        // Formats a date as a three-letter weekday like "Thu" — used as the
        // x-axis labels on the Progress screen's weekly activity chart.
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: self)
    }
}

extension Double {
    func formatted(decimals: Int = 1) -> String {
        // Rounds a Double to a chosen number of decimal places and returns
        // it as text, e.g. 68.456.formatted(decimals: 0) -> "68".
        // Saves us from writing String(format:) everywhere a number needs
        // to be displayed (weights, BMI, goal amounts, etc).
        String(format: "%.\(decimals)f", self)
    }
}
