import SwiftUI

struct ExerciseProgressionSettingsView: View {
    @Binding var exercise: Exercise
    @State private var targetReps: Int
    @State private var weightIncrement: Double
    @State private var selectedStrategy: ProgressionStrategy
    
    init(exercise: Binding<Exercise>) {
        self._exercise = exercise
        self._targetReps = State(initialValue: exercise.wrappedValue.targetReps)
        self._weightIncrement = State(initialValue: exercise.wrappedValue.weightIncrement)
        self._selectedStrategy = State(initialValue: exercise.wrappedValue.progressionStrategy)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Progression Goals")) {
                Stepper("Target Reps: \(targetReps)", value: $targetReps, in: 1...30)
                
                HStack {
                    Text("Weight Increment:")
                    TextField("Weight", value: $weightIncrement, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                    Text("lbs")
                }
                
                Picker("Progression Strategy", selection: $selectedStrategy) {
                    ForEach([ProgressionStrategy.weight, .reps, .both], id: \.self) { strategy in
                        Text(strategy.rawValue).tag(strategy)
                    }
                }
            }
            
            Section {
                Button("Save Settings") {
                    saveSettings()
                }
            }
        }
    }
    
    private func saveSettings() {
        exercise.targetReps = targetReps
        exercise.weightIncrement = weightIncrement
        exercise.progressionStrategy = selectedStrategy
    }
}

// Preview provider for SwiftUI canvas
struct ExerciseProgressionSettingsView_Previews: PreviewProvider {
    @State static var exercise = Exercise(name: "Preview Exercise", sets: 3, restPeriod: 60)
    
    static var previews: some View {
        ExerciseProgressionSettingsView(exercise: $exercise)
    }
}
