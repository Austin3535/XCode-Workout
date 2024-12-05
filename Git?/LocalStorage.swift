import Foundation
import SwiftUI

class LocalStorage {
    static let shared = LocalStorage()
    private let workoutsKey = "savedWorkouts"
    private let completedWorkoutsKey = "completedWorkouts"
    private let previousSetsKey = "previousSets"
    
    private init() {}
    
    func saveWorkouts(_ workouts: [Workout]) {
        do {
            let encoded = try JSONEncoder().encode(workouts)
            UserDefaults.standard.set(encoded, forKey: workoutsKey)
            UserDefaults.standard.synchronize()
            print("DEBUG: Successfully saved \(workouts.count) workouts")
        } catch {
            print("DEBUG: Error saving workouts: \(error)")
        }
    }
    
    func loadWorkouts() -> [Workout] {
        guard let data = UserDefaults.standard.data(forKey: workoutsKey) else {
            print("DEBUG: No workouts data found in UserDefaults")
            return []
        }
        
        do {
            let workouts = try JSONDecoder().decode([Workout].self, from: data)
            print("DEBUG: Successfully loaded \(workouts.count) workouts")
            return workouts
        } catch {
            print("DEBUG: Error decoding workouts: \(error)")
            return []
        }
    }
    
    func saveCompletedWorkouts(_ workouts: [Workout]) {
        do {
            let encoded = try JSONEncoder().encode(workouts)
            UserDefaults.standard.set(encoded, forKey: completedWorkoutsKey)
            UserDefaults.standard.synchronize()
            print("DEBUG: Successfully saved \(workouts.count) completed workouts")
        } catch {
            print("DEBUG: Error saving completed workouts: \(error)")
        }
    }
    
    func loadCompletedWorkouts() -> [Workout] {
        guard let data = UserDefaults.standard.data(forKey: completedWorkoutsKey) else {
            print("DEBUG: No completed workouts data found in UserDefaults")
            return []
        }
        
        do {
            let workouts = try JSONDecoder().decode([Workout].self, from: data)
            print("DEBUG: Successfully loaded \(workouts.count) completed workouts")
            return workouts
        } catch {
            print("DEBUG: Error decoding completed workouts: \(error)")
            return []
        }
    }
    
    func savePreviousSets(_ sets: [UUID: [WorkoutSet]]) {
        do {
            let encoded = try JSONEncoder().encode(sets)
            UserDefaults.standard.set(encoded, forKey: previousSetsKey)
            UserDefaults.standard.synchronize()
            print("DEBUG: Successfully saved sets for \(sets.count) exercises")
        } catch {
            print("DEBUG: Error saving previous sets: \(error)")
        }
    }
    
    func loadPreviousSets() -> [UUID: [WorkoutSet]] {
        guard let data = UserDefaults.standard.data(forKey: previousSetsKey) else {
            print("DEBUG: No previous sets data found in UserDefaults")
            return [:]
        }
        
        do {
            let sets = try JSONDecoder().decode([UUID: [WorkoutSet]].self, from: data)
            print("DEBUG: Successfully loaded sets for \(sets.count) exercises")
            return sets
        } catch {
            print("DEBUG: Error decoding previous sets: \(error)")
            return [:]
        }
    }
    
    // Helper method to clear all stored data (useful for debugging)
    func clearAllData() {
        UserDefaults.standard.removeObject(forKey: workoutsKey)
        UserDefaults.standard.removeObject(forKey: completedWorkoutsKey)
        UserDefaults.standard.removeObject(forKey: previousSetsKey)
        UserDefaults.standard.synchronize()
        print("DEBUG: Cleared all stored data")
    }
    
    // Helper method to print current storage state
    func printStorageState() {
        print("DEBUG: --- Storage State ---")
        if let workoutsData = UserDefaults.standard.data(forKey: workoutsKey) {
            print("Workouts data size: \(workoutsData.count) bytes")
        } else {
            print("No workouts data stored")
        }
        
        if let completedData = UserDefaults.standard.data(forKey: completedWorkoutsKey) {
            print("Completed workouts data size: \(completedData.count) bytes")
        } else {
            print("No completed workouts data stored")
        }
        
        if let setsData = UserDefaults.standard.data(forKey: previousSetsKey) {
            print("Previous sets data size: \(setsData.count) bytes")
        } else {
            print("No previous sets data stored")
        }
        print("------------------------")
    }
}
