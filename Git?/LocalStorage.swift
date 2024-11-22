import Foundation
import SwiftUI

class LocalStorage {
    static let shared = LocalStorage()
    private let workoutsKey = "savedWorkouts"
    private let completedWorkoutsKey = "completedWorkouts"
    private let previousSetsKey = "previousSets"
    
    private init() {}
    
    func saveWorkouts(_ workouts: [Workout]) {
        if let encoded = try? JSONEncoder().encode(workouts) {
            UserDefaults.standard.set(encoded, forKey: workoutsKey)
            print("DEBUG: Saved \(workouts.count) workouts")
        }
    }
    
    func loadWorkouts() -> [Workout] {
        if let data = UserDefaults.standard.data(forKey: workoutsKey),
           let workouts = try? JSONDecoder().decode([Workout].self, from: data) {
            print("DEBUG: Loaded \(workouts.count) workouts")
            return workouts
        }
        print("DEBUG: No workouts found in storage")
        return []
    }
    
    func saveCompletedWorkouts(_ workouts: [Workout]) {
        if let encoded = try? JSONEncoder().encode(workouts) {
            UserDefaults.standard.set(encoded, forKey: completedWorkoutsKey)
            print("DEBUG: Saved \(workouts.count) completed workouts")
        }
    }
    
    func loadCompletedWorkouts() -> [Workout] {
        if let data = UserDefaults.standard.data(forKey: completedWorkoutsKey),
           let workouts = try? JSONDecoder().decode([Workout].self, from: data) {
            print("DEBUG: Loaded \(workouts.count) completed workouts")
            return workouts
        }
        print("DEBUG: No completed workouts found in storage")
        return []
    }
    
    func savePreviousSets(_ sets: [UUID: [WorkoutSet]]) {
        if let encoded = try? JSONEncoder().encode(sets) {
            UserDefaults.standard.set(encoded, forKey: previousSetsKey)
            print("DEBUG: Saved sets for \(sets.count) exercises")
        }
    }
    
    func loadPreviousSets() -> [UUID: [WorkoutSet]] {
        if let data = UserDefaults.standard.data(forKey: previousSetsKey),
           let sets = try? JSONDecoder().decode([UUID: [WorkoutSet]].self, from: data) {
            print("DEBUG: Loaded sets for \(sets.count) exercises")
            return sets
        }
        print("DEBUG: No previous sets found in storage")
        return [:]
    }
}
