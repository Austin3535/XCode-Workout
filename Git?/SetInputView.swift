import SwiftUI

struct SetInputView: View {
    let setNumber: Int
    let exerciseId: UUID
    @Binding var setsData: [UUID: [WorkoutSet]]
    let remainingRestTime: Int
    let isLastSet: Bool
    let onStartRest: () -> Void  // Add this line
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 20) {
                // Set Number Circle
                ZStack {
                    Circle()
                        .fill(Color(.systemGray6))
                        .frame(width: 40, height: 40)
                    Text("\(setNumber)")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                
                // Weight Input
                VStack(alignment: .leading, spacing: 4) {
                    Text("Weight")
                        .font(.caption)
                        .foregroundColor(.gray)
                    HStack {
                        TextField("0", value: weightBinding, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 80)
                        Text("lbs")
                            .foregroundColor(.gray)
                    }
                }
                
                // Reps Input
                VStack(alignment: .leading, spacing: 4) {
                    Text("Reps")
                        .font(.caption)
                        .foregroundColor(.gray)
                    TextField("0", value: repsBinding, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 80)
                }
                
                Spacer()
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            
            // Rest Timer Display
            if !isLastSet && remainingRestTime > 0 {
                HStack {
                    Image(systemName: "timer")
                        .foregroundColor(.blue)
                    Text("Rest: \(remainingRestTime)s")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .padding(.vertical, 8)
                .onTapGesture {
                    onStartRest()  // Add this line
                }
            }
        }
    }
    
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
}//
//  SetInputView.swift
//  Git?
//
//  Created by Austin Emfield on 12/4/24.
//

