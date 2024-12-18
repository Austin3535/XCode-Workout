import SwiftUI

struct TrackWorkoutView: View {
    @EnvironmentObject var routine: Routine
    @Environment(\.presentationMode) var presentationMode
    @State private var setsData: [UUID: [WorkoutSet]] = [:]
    @State private var restTimer: Timer?
    @State private var remainingRestTime: Int = 0
    @State private var showingProgressionSettings = false
    @State private var selectedExercise: Exercise?
    @State private var expandedExercise: UUID?
    var day: Day
    
    var body: some View {
        List {
            ForEach(day.exercises) { exercise in
                DisclosureGroup(
                    isExpanded: Binding(
                        get: { expandedExercise == exercise.id },
                        set: { if $0 { expandedExercise = exercise.id } else { expandedExercise = nil } }
                    )
                ) {
                    VStack(spacing: 12) {
                        // Progression Suggestion Display
                        if let suggestion = routine.progressionSuggestions[exercise.id] {
                            Text(suggestion.message)
                                .font(.system(size: 16, weight: .medium)) // Adjust font size and weight here
                                .padding(12)  // Adjust internal padding here
                                .frame(maxWidth: .infinity) // Makes the box take full width
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(8)  // Adjust corner roundness here
                                .padding(.bottom, 10) // Adjust spacing below the box
                        }
                        
                        // Exercise Sets Input with Grid
                        LazyVGrid(
                            columns: [
                                GridItem(.adaptive(minimum: 300))
                            ],
                            spacing: 8
                        ) {
                            ForEach(0..<exercise.sets, id: \.self) { setIndex in
                                SetInputView(
                                    setNumber: setIndex + 1,
                                    exerciseId: exercise.id,
                                    setsData: $setsData,
                                    remainingRestTime: remainingRestTime,
                                    isLastSet: setIndex == exercise.sets - 1,
                                    onStartRest: {
                                        startRestTimer(for: exercise.customRestPeriod ?? exercise.restPeriod)
                                    }
                                )
                            }
                        }
                        
                        // Previous Sets Display
                        if let previousSets = routine.previousSets[exercise.id],
                           !previousSets.isEmpty {
                            PreviousSetsView(previousSets: previousSets)
                        }
                    }
                } label: {
                    HStack {
                        Text(exercise.name)
                            .font(.headline)
                        Spacer()
                        
                        Button(action: {
                            selectedExercise = exercise
                            showingProgressionSettings = true
                        }) {
                            Image(systemName: "gear")
                                .foregroundColor(.gray)
                        }
                        
                        Button(action: {
                            startRestTimer(for: exercise.customRestPeriod ?? exercise.restPeriod)
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "timer")
                                if remainingRestTime > 0 {
                                    Text("\(remainingRestTime)s")
                                        .font(.caption)
                                }
                            }
                            .foregroundColor(.blue)
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
        .sheet(isPresented: $showingProgressionSettings) {
            if let exercise = selectedExercise {
                NavigationView {
                    ExerciseProgressionSettingsView(exercise: .constant(exercise))
                        .navigationTitle("Progression Settings")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Done") {
                                    showingProgressionSettings = false
                                }
                            }
                        }
                }
            }
        }
        .onDisappear {
            restTimer?.invalidate()
        }
    }
    
    // MARK: - Helper Functions
    func getSetData(for exerciseID: UUID, at index: Int) -> WorkoutSet? {
        if let sets = setsData[exerciseID], sets.count > index {
            return sets[index]
        }
        return nil
    }
    
    func setWeight(_ weight: Double, for exerciseID: UUID, at index: Int) {
        if setsData[exerciseID] == nil {
            setsData[exerciseID] = Array(repeating: WorkoutSet(weight: 0, reps: 0), count: index + 1)
        }
        if setsData[exerciseID]!.count <= index {
            setsData[exerciseID]!.append(WorkoutSet(weight: weight, reps: 0))
        } else {
            let currentSet = setsData[exerciseID]![index]
            setsData[exerciseID]![index] = WorkoutSet(weight: weight, reps: currentSet.reps)
        }
    }
    
    func setReps(_ reps: Int, for exerciseID: UUID, at index: Int) {
        if setsData[exerciseID] == nil {
            setsData[exerciseID] = Array(repeating: WorkoutSet(weight: 0, reps: 0), count: index + 1)
        }
        if setsData[exerciseID]!.count <= index {
            setsData[exerciseID]!.append(WorkoutSet(weight: 0, reps: reps))
        } else {
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
            
            if let exercise = day.exercises.first(where: { $0.id == exerciseID }) {
                if let suggestion = ProgressionManager.analyzeSets(sets, for: exercise) {
                    routine.progressionSuggestions[exerciseID] = suggestion
                }
            }
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

// MARK: - Preview
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
