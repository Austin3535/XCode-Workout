import SwiftUI

struct PastWorkoutDetailView: View {
    @EnvironmentObject var routine: Routine
    var workout: Workout

    var body: some View {
        List {
            ForEach(workout.days) { day in
                Section(header: Text(day.name)) {
                    ForEach(day.exercises) { exercise in
                        if let previousSets = routine.previousSets[exercise.id] {
                            // Changed this ForEach to use enumerated and a compound ID
                            ForEach(Array(zip(previousSets.indices, previousSets)), id: \.0) { index, set in
                                HStack {
                                    Text("Weight: \(set.weight, specifier: "%.1f") lbs")
                                    Spacer()
                                    Text("Reps: \(set.reps)")
                                    Spacer()
                                    Text("\(set.date, formatter: dateFormatter)")
                                }
                            }
                        } else {
                            Text("No sets recorded for \(exercise.name)")
                        }
                    }
                }
            }
        }
        .navigationTitle(workout.name)
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
}
struct PastWorkoutDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PastWorkoutDetailView(
                workout: Workout(
                    name: "Sample Workout",
                    days: [
                        Day(name: "Day 1", exercises: [
                            Exercise(name: "Bench Press", sets: 3, restPeriod: 120, customRestPeriod: nil)
                        ])
                    ]
                )
            )
            .environmentObject(Routine())
        }
    }
}//
//  PastWorkoutDetailView.swift
//  Git?
//
//  Created by Austin Emfield on 11/22/24.
//

