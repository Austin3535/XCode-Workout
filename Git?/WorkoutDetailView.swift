// WorkoutDetailView.swift
import SwiftUI

struct WorkoutDetailView: View {
    var workout: Workout

    var body: some View {
        List {
            ForEach(workout.days) { day in
                NavigationLink(destination: TrackWorkoutView(day: day)) {
                    Text(day.name)
                }
            }
        }
        .navigationTitle(workout.name)
    }
}

struct WorkoutDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WorkoutDetailView(workout: Workout(
                name: "Sample Workout",
                days: [Day(name: "Day 1", exercises: [])]
            ))
        }
    }
}//
//  WorkoutDetailView.swift
//  Git?
//
//  Created by Austin Emfield on 11/21/24.
//

