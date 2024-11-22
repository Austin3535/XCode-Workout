import SwiftUI

struct PresetWorkoutView: View {
    @EnvironmentObject var routine: Routine
    @Environment(\.presentationMode) var presentationMode

    let presetWorkouts: [Workout] = [
        Workout(name: "Full Body Workout", days: [
            Day(name: "Day 1", exercises: [
                Exercise(name: "Squats", sets: 3, restPeriod: 300, customRestPeriod: nil),
                Exercise(name: "Bench Press", sets: 3, restPeriod: 300, customRestPeriod: nil),
                Exercise(name: "Deadlift", sets: 3, restPeriod: 300, customRestPeriod: nil)
            ]),
            Day(name: "Day 2", exercises: [
                Exercise(name: "Pull-ups", sets: 3, restPeriod: 120, customRestPeriod: nil),
                Exercise(name: "Overhead Press", sets: 3, restPeriod: 120, customRestPeriod: nil),
                Exercise(name: "Rows", sets: 3, restPeriod: 120, customRestPeriod: nil)
            ])
        ]),
        Workout(name: "Upper/Lower Split", days: [
            Day(name: "Upper Body", exercises: [
                Exercise(name: "Bench Press", sets: 3, restPeriod: 120, customRestPeriod: nil),
                Exercise(name: "Rows", sets: 3, restPeriod: 120, customRestPeriod: nil),
                Exercise(name: "Overhead Press", sets: 3, restPeriod: 120, customRestPeriod: nil),
                Exercise(name: "Pull-ups", sets: 3, restPeriod: 120, customRestPeriod: nil)
            ]),
            Day(name: "Lower Body", exercises: [
                Exercise(name: "Squats", sets: 3, restPeriod: 300, customRestPeriod: nil),
                Exercise(name: "Deadlift", sets: 3, restPeriod: 300, customRestPeriod: nil),
                Exercise(name: "Leg Press", sets: 3, restPeriod: 120, customRestPeriod: nil),
                Exercise(name: "Calf Raises", sets: 3, restPeriod: 60, customRestPeriod: nil)
            ])
        ])
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach(presetWorkouts) { workout in
                    Button(action: {
                        addPresetWorkout(workout)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text(workout.name)
                    }
                }
            }
            .navigationTitle("Preset Workouts")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

    func addPresetWorkout(_ workout: Workout) {
        routine.workouts.append(workout)
    }
}

struct PresetWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        PresetWorkoutView()
            .environmentObject(Routine())
    }
}
