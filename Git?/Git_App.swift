import SwiftUI

@main
struct Git_App: App {
    @StateObject private var routine = Routine()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(routine)
        }
    }
}
