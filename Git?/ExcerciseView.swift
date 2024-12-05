import SwiftUI

struct ExerciseView: View {
    @EnvironmentObject var routine: Routine
    let exercise: Exercise
    @State private var showProgressionSettings = false
    @State private var exerciseModel: Exercise
    
    init(exercise: Exercise) {
        self.exercise = exercise
        self._exerciseModel = State(initialValue: exercise)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Exercise Name and Settings Button
            HStack {
                Text(exercise.name)
                    .font(.headline)
                Spacer()
                Button(action: {
                    showProgressionSettings.toggle()
                }) {
                    Image(systemName: "gear")
                }
            }
            
            // Sets and Rest Period Info
            Text("Sets: \(exercise.sets)")
            Text("Rest Period: \(exercise.restPeriod)s")
            
            // Progression Suggestion if available
            if let suggestion = routine.progressionSuggestions[exercise.id] {
                VStack(alignment: .leading) {
                    Text("Progression Suggestion:")
                        .font(.subheadline)
                        .bold()
                    Text(suggestion.message)
                        .padding()
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            
            // Previous Sets if available
            if let previousSets = routine.previousSets[exercise.id], !previousSets.isEmpty {
                VStack(alignment: .leading) {
                    Text("Previous Sets:")
                        .font(.subheadline)
                        .bold()
                    ForEach(previousSets.suffix(3)) { set in
                        Text("\(set.weight, specifier: "%.1f")lbs × \(set.reps) reps")
                            .font(.caption)
                    }
                }
            }
        }
        .padding()
        .sheet(isPresented: $showProgressionSettings) {
            NavigationView {
                ExerciseProgressionSettingsView(exercise: $exerciseModel)
                    .navigationTitle("Progression Settings")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                showProgressionSettings = false
                            }
                        }
                    }
            }
        }
    }
}//
//  ExcerciseView.swift
//  Git?
//
//  Created by Austin Emfield on 12/4/24.
//

