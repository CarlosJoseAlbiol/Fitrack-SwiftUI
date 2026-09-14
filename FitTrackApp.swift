import SwiftUI

@main
// "@main" tells Swift: "this is the entry point — start the app here."
// There can only be one @main in the whole project.
struct FitTrackApp: App {
    // Conforming to "App" (a SwiftUI protocol) is what makes this struct
    // eligible to be the app's starting point.

    @StateObject private var dataController = GymDataController()
    // This is where the single, shared GymDataController instance is
    // actually created — once, when the app launches. "@StateObject" (as
    // opposed to plain "@ObservedObject") guarantees SwiftUI keeps this
    // exact instance alive for the entire lifetime of the app, instead of
    // accidentally recreating it every time a screen redraws.

    var body: some Scene {
        // Every SwiftUI App must describe its "Scene" — essentially, what
        // window(s) the app shows.
        WindowGroup {
            // WindowGroup represents the app's main window (on iOS, this
            // is just the one full-screen window the whole app lives in).
            RootTabView()
                // The very first screen the user sees — our tab bar.
                .environmentObject(dataController)
                // This is the crucial line that makes the controller
                // available to every single screen in the app without
                // manually passing it down through each View's
                // initializer. Any screen can write
                // "@EnvironmentObject var controller: GymDataController"
                // and it will automatically receive this exact instance.
                .preferredColorScheme(.dark)
                // Forces the whole app into dark mode regardless of the
                // device's system setting, since the entire UI was
                // designed around a dark background.
        }
    }
}
