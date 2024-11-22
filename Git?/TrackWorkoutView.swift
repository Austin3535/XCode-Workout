import SwiftUI

struct TrackWorkoutView: View {
    @EnvironmentObject var routine: Routine
    @Environment(\.presentationMode) var presentationMode
    @State private var setsData: [UUID: [WorkoutSet]] = [:]  // Changed Set to WorkoutSet
    @State private var restTimer: Timer?
    @State private var remainingRestTime: Int = 0
    var day: Day

    var body: some View {
        List {
            ForEach(day.exercises) { exercise in
                Section(header: HStack {
                    Text(exercise.name)
                    Spacer()
                    Button(action: {
                        startRestTimer(for: exercise.customRestPeriod ?? exercise.restPeriod)
                    }) {
                        HStack {
                            Text("Start Rest Timer")
                            if remainingRestTime > 0 {
                                Text("(\(remainingRestTime) sec)")
                            }
                        }
                    }
                }) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: exercise.sets)) {
                        ForEach(0..<exercise.sets, id: \.self) { setIndex in
                            VStack {
                                Text("Set \(setIndex + 1)")
                                let weightBinding = Binding(
                                    get: { getSetData(for: exercise.id, at: setIndex)?.weight ?? 0 },
                                    set: { setWeight($0, for: exercise.id, at: setIndex) }
                                )
                                TextField("Weight", value: weightBinding, formatter: NumberFormatter())
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 80)
                                
                                let repsBinding = Binding(
                                    get: { getSetData(for: exercise.id, at: setIndex)?.reps ?? 0 },
                                    set: { setReps($0, for: exercise.id, at: setIndex) }
                                )
                                TextField("Reps", value: repsBinding, formatter: NumberFormatter())
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 80)
                                
                                if setIndex < exercise.sets - 1 {
                                    if remainingRestTime > 0 {
                                        Text("Resting: \(remainingRestTime) sec")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(day.name)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Save") {
                    saveWorkoutData()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Complete Workout") {
                    completeWorkout()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .onDisappear {
            restTimer?.invalidate()
        }
    }

    func getSetData(for exerciseID: UUID, at index: Int) -> WorkoutSet? {  // Changed Set to WorkoutSet
            if let sets = setsData[exerciseID], sets.count > index {
                return sets[index]
            }
            return nil
        }

        func setWeight(_ weight: Double, for exerciseID: UUID, at index: Int) {
            if setsData[exerciseID] == nil {
                setsData[exerciseID] = Array(repeating: WorkoutSet(weight: 0, reps: 0), count: index + 1)  // Changed Set to WorkoutSet
            }
            if setsData[exerciseID]!.count <= index {
                setsData[exerciseID]!.append(WorkoutSet(weight: weight, reps: 0))  // Changed Set to WorkoutSet
            } else {
                // Need to create a new WorkoutSet since it's immutable
                let currentSet = setsData[exerciseID]![index]
                setsData[exerciseID]![index] = WorkoutSet(weight: weight, reps: currentSet.reps)
            }
        }

        func setReps(_ reps: Int, for exerciseID: UUID, at index: Int) {
            if setsData[exerciseID] == nil {
                setsData[exerciseID] = Array(repeating: WorkoutSet(weight: 0, reps: 0), count: index + 1)  // Changed Set to WorkoutSet
            }
            if setsData[exerciseID]!.count <= index {
                setsData[exerciseID]!.append(WorkoutSet(weight: 0, reps: reps))  // Changed Set to WorkoutSet
            } else {
                // Need to create a new WorkoutSet since it's immutable
                let currentSet = setsData[exerciseID]![index]
                setsData[exerciseID]![index] = WorkoutSet(weight: currentSet.weight, reps: reps)
            }
        }

    func saveWorkoutData() {
        for (exerciseID, sets) in setsData {
            if routine.previousSets[exerciseID] == nil {
                routine.previousSets[exerciseID] = []
            }
            routine.previousSets[exerciseID]?.append(contentsOf: sets)
        }
    }

    func completeWorkout() {
        saveWorkoutData()
        var completedWorkout = Workout(name: day.name, days: [day])
        completedWorkout.completionDate = Date()
        routine.completedWorkouts.append(completedWorkout)
    }

    func startRestTimer(for duration: Int) {
        remainingRestTime = duration
        restTimer?.invalidate()
        restTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if remainingRestTime > 0 {
                remainingRestTime -= 1
            } else {
                timer.invalidate()
            }
        }
    }
}

struct TrackWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TrackWorkoutView(day: Day(
                name: "Sample Day",
                exercises: [
                    Exercise(name: "Bench Press", sets: 3, restPeriod: 120, customRestPeriod: nil)
                ]
            ))
            .environmentObject(Routine())
        }
    }
}
