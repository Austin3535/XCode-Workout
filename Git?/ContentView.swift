import SwiftUI

struct ContentView: View {
    @StateObject var routine = Routine()
    @State private var showingAddWorkout = false
    @State private var showingPresetWorkouts = false
    @State private var showingPastWorkouts = false

    var body: some View {
        NavigationView {
            List {
                ForEach(routine.workouts) { workout in
                    NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                        Text(workout.name)
                    }
                }
            }
            .navigationTitle("My Workouts")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    HStack {
                        Button(action: { showingPresetWorkouts.toggle() }) {
                            Image(systemName: "list.bullet")
                        }
                        Button(action: { showingAddWorkout.toggle() }) {
                            Image(systemName: "plus")
                        }
                        Button(action: { showingPastWorkouts.toggle() }) {
                            Image(systemName: "clock.arrow.circlepath")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddWorkout) {
                AddWorkoutView()
                    .environmentObject(routine)
            }
            .sheet(isPresented: $showingPresetWorkouts) {
                PresetWorkoutView()
                    .environmentObject(routine)
            }
            .sheet(isPresented: $showingPastWorkouts) {
                PastWorkoutsView()  // This is where the error is occurring
                    .environmentObject(routine)
            }
        }
        .environmentObject(routine)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Routine())
    }
}
