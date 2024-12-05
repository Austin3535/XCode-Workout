//
//  ProgressionManager.swift
//  Git?
//
//  Created by Austin Emfield on 12/4/24.
//

import Foundation

class ProgressionManager {
    static func analyzeSets(_ sets: [WorkoutSet], for exercise: Exercise) -> ProgressionSuggestion? {
        let recentSets = sets.sorted(by: { $0.date > $1.date })
        guard !recentSets.isEmpty else { return nil }
        
        let averageWeight = recentSets.map { $0.weight }.reduce(0, +) / Double(recentSets.count)
        let averageReps = recentSets.map { $0.reps }.reduce(0, +) / recentSets.count
        
        // Check if enough time has passed since last progression
        if let lastProgressionDate = exercise.lastProgressionDate {
            let daysSinceProgression = Calendar.current.dateComponents([.day], from: lastProgressionDate, to: Date()).day ?? 0
            if daysSinceProgression < 7 { // Minimum 7 days between progression suggestions
                return nil
            }
        }
        
        switch exercise.progressionStrategy {
        case .weight:
            if averageReps >= exercise.targetReps {
                return ProgressionSuggestion(
                    exerciseId: exercise.id,
                    suggestedWeight: averageWeight + exercise.weightIncrement,
                    suggestedReps: exercise.targetReps,
                    message: "Ready to increase weight by \(exercise.weightIncrement)lbs!"
                )
            }
        case .reps:
            if averageReps >= exercise.targetReps {
                return ProgressionSuggestion(
                    exerciseId: exercise.id,
                    suggestedWeight: averageWeight,
                    suggestedReps: averageReps + 1,
                    message: "Try adding 1 rep to each set!"
                )
            }
        case .both:
            if averageReps >= exercise.targetReps {
                return ProgressionSuggestion(
                    exerciseId: exercise.id,
                    suggestedWeight: averageWeight + exercise.weightIncrement,
                    suggestedReps: averageReps + 1,
                    message: "Increase both weight and reps!"
                )
            }
        }
        
        return nil
    }
}
