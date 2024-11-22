import Foundation

class LocalStorage {
    static let shared = LocalStorage()
    private let workoutsKey = "savedWorkouts"
    private let completedWorkoutsKey = "completedWorkouts"
    private let previousSetsKey = "previousSets"
    
    private init() {}
    
    // Save workouts
    func saveWorkouts(_ workouts: [Workout]) {
        if let encoded = try? JSONEncoder().encode(workouts) {
            UserDefaults.standard.set(encoded, forKey: workoutsKey)
        }
    }
    
    // Load workouts
    func loadWorkouts() -> [Workout] {
        if let data = UserDefaults.standard.data(forKey: workoutsKey),
           let workouts = try? JSONDecoder().decode([Workout].self, from: data) {
            return workouts
        }
        return []
    }
    
    // Save completed workouts
    func saveCompletedWorkouts(_ workouts: [Workout]) {
        if let encoded = try? JSONEncoder().encode(workouts) {
            UserDefaults.standard.set(encoded, forKey: completedWorkoutsKey)
        }
    }
    
    // Load completed workouts
    func loadCompletedWorkouts() -> [Workout] {
        if let data = UserDefaults.standard.data(forKey: completedWorkoutsKey),
           let workouts = try? JSONDecoder().decode([Workout].self, from: data) {
            return workouts
        }
        return []
    }
    
    // Save previous sets
    func savePreviousSets(_ sets: [UUID: [WorkoutSet]]) {
        if let encoded = try? JSONEncoder().encode(sets) {
            UserDefaults.standard.set(encoded, forKey: previousSetsKey)
        }
    }
    
    // Load previous sets
    func loadPreviousSets() -> [UUID: [WorkoutSet]] {
        if let data = UserDefaults.standard.data(forKey: previousSetsKey),
           let sets = try? JSONDecoder().decode([UUID: [WorkoutSet]].self, from: data) {
            return sets
        }
        return [:]
    }
}//
//  LocalStorage.swift
//  Git?
//
//  Created by Austin Emfield on 11/22/24.
//

