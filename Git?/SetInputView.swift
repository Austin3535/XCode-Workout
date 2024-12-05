import SwiftUI

struct SetInputView: View {
    let setNumber: Int
    let exerciseId: UUID
    @Binding var setsData: [UUID: [WorkoutSet]]
    let remainingRestTime: Int
    let isLastSet: Bool
    let onStartRest: () -> Void
    
    var body: some View {
        // Adjust overall horizontal spacing between elements
        HStack(spacing: 16) {
            // Set Number Circle
            ZStack {
                Circle()
                    .fill(Color(.systemGray6))
                    // Adjust circle size here
                    .frame(width: 40, height: 40)
                Text("\(setNumber)")
                    // Adjust set number font size and weight here
                    .font(.system(size: 16, weight: .semibold))
            }
            
            // Adjust vertical spacing between "Weight"/"Reps" label and their input fields
            VStack(alignment: .leading, spacing: 4) {
                // Adjust horizontal spacing between Weight and Reps sections
                HStack(spacing: 12) {
                    // Weight Input
                    VStack(alignment: .leading) {
                        Text("Weight")
                            // Adjust "Weight" label font size here
                            .font(.caption)
                            .foregroundColor(.gray)
                        // Adjust spacing between TextField and "lbs"
                        HStack(spacing: 4) {
                            TextField("0", value: weightBinding, formatter: NumberFormatter())
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                // Adjust width of weight input field
                                .frame(width: 80)
                            Text("lbs")
                                // Adjust "lbs" font size here
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Reps Input
                    VStack(alignment: .leading) {
                        Text("Reps")
                            // Adjust "Reps" label font size here
                            .font(.caption)
                            .foregroundColor(.gray)
                        TextField("0", value: repsBinding, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            // Adjust width of reps input field
                            .frame(width: 80)
                    }
                }
            }
            
            Spacer()
            
            // Rest Timer
            if !isLastSet && remainingRestTime > 0 {
                VStack(alignment: .trailing) {
                    Text("\(remainingRestTime)s")
                        // Adjust timer number font size here
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                    Text("rest")
                        // Adjust "rest" label font size here
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .onTapGesture(perform: onStartRest)
            }
        }
        // Adjust overall padding around the entire view
        .padding()
        .background(Color(.systemBackground))
        // Adjust corner rounding here
        .cornerRadius(10)
        // Adjust shadow properties here
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    // Keep all your existing bindings and functions below this
    private var weightBinding: Binding<Double> {
        Binding(
            get: { getSetData()?.weight ?? 0 },
            set: { setWeight($0) }
        )
    }
    
    private var repsBinding: Binding<Int> {
        Binding(
            get: { getSetData()?.reps ?? 0 },
            set: { setReps($0) }
        )
    }
    
    private func getSetData() -> WorkoutSet? {
        if let sets = setsData[exerciseId], sets.count > setNumber - 1 {
            return sets[setNumber - 1]
        }
        return nil
    }
    
    private func setWeight(_ weight: Double) {
        if setsData[exerciseId] == nil {
            setsData[exerciseId] = Array(repeating: WorkoutSet(weight: 0, reps: 0), count: setNumber)
        }
        if setsData[exerciseId]!.count <= setNumber - 1 {
            setsData[exerciseId]!.append(WorkoutSet(weight: weight, reps: 0))
        } else {
            let currentSet = setsData[exerciseId]![setNumber - 1]
            setsData[exerciseId]![setNumber - 1] = WorkoutSet(weight: weight, reps: currentSet.reps)
        }
    }
    
    private func setReps(_ reps: Int) {
        if setsData[exerciseId] == nil {
            setsData[exerciseId] = Array(repeating: WorkoutSet(weight: 0, reps: 0), count: setNumber)
        }
        if setsData[exerciseId]!.count <= setNumber - 1 {
            setsData[exerciseId]!.append(WorkoutSet(weight: 0, reps: reps))
        } else {
            let currentSet = setsData[exerciseId]![setNumber - 1]
            setsData[exerciseId]![setNumber - 1] = WorkoutSet(weight: currentSet.weight, reps: reps)
        }
    }
}

// MARK: - Preview
struct SetInputView_Previews: PreviewProvider {
    @State static var mockSetsData: [UUID: [WorkoutSet]] = [:]
    static let mockExerciseId = UUID()
    
    static var previews: some View {
        VStack(spacing: 20) {
            SetInputView(
                setNumber: 1,
                exerciseId: mockExerciseId,
                setsData: .constant(mockSetsData),
                remainingRestTime: 60,
                isLastSet: false,
                onStartRest: {}
            )
            
            SetInputView(
                setNumber: 2,
                exerciseId: mockExerciseId,
                setsData: .constant(mockSetsData),
                remainingRestTime: 0,
                isLastSet: false,
                onStartRest: {}
            )
            
            SetInputView(
                setNumber: 3,
                exerciseId: mockExerciseId,
                setsData: .constant(mockSetsData),
                remainingRestTime: 30,
                isLastSet: true,
                onStartRest: {}
            )
        }
        .padding()
        .background(Color(.systemBackground))
        .previewLayout(.sizeThatFits)
    }
}
