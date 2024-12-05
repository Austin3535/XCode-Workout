import Foundation
import SwiftUI

// MARK: - Workout Model
struct Workout: Identifiable, Codable {
    var id: UUID
    var name: String
    var days: [Day]
    var completionDate: Date?
    
    init(name: String, days: [Day]) {
        self.id = UUID()
        self.name = name
        self.days = days
        self.completionDate = nil
    }
}

// MARK: - Day Model
struct Day: Identifiable, Codable {
    var id: UUID
    var name: String
    var exercises: [Exercise]
    
    init(name: String, exercises: [Exercise]) {
        self.id = UUID()
        self.name = name
        self.exercises = exercises
    }
}

// MARK: - Exercise Model
struct Exercise: Identifiable, Codable {
    var id: UUID
    var name: String
    var sets: Int
    var restPeriod: Int
    var customRestPeriod: Int?
    
    init(name: String, sets: Int, restPeriod: Int, customRestPeriod: Int? = nil) {
        self.id = UUID()
        self.name = name
        self.sets = sets
        self.restPeriod = restPeriod
        self.customRestPeriod = customRestPeriod
    }
}

// MARK: - WorkoutSet Model
struct WorkoutSet: Identifiable, Codable {
    let id: UUID         // Keeping as let since it's an identifier
    var weight: Double
    var reps: Int
    let date: Date      // Keeping as let since it's set once at creation
    
    init(weight: Double, reps: Int) {
        self.id = UUID()
        self.weight = weight
        self.reps = reps
        self.date = Date()
    }
}

// MARK: - Routine Class
class Routine: ObservableObject {
    @Published var workouts: [Workout] = [] {
        didSet {
            saveData()
        }
    }
    
    @Published var completedWorkouts: [Workout] = [] {
        didSet {
            saveData()
        }
    }
    
    @Published var previousSets: [UUID: [WorkoutSet]] = [:] {
        didSet {
            saveData()
        }
    }
    
    init() {
        print("DEBUG: Initializing Routine")
        loadData()
    }
    
    private func loadData() {
        // Load all data first
        let loadedWorkouts = LocalStorage.shared.loadWorkouts()
        let loadedCompletedWorkouts = LocalStorage.shared.loadCompletedWorkouts()
        let loadedPreviousSets = LocalStorage.shared.loadPreviousSets()
        
        // Then assign to properties
        self.workouts = loadedWorkouts
        self.completedWorkouts = loadedCompletedWorkouts
        self.previousSets = loadedPreviousSets
        
        print("DEBUG: Loaded data - Workouts: \(workouts.count), Completed: \(completedWorkouts.count), Sets: \(previousSets.count)")
    }
    
    private func saveData() {
        // Only save if there's actually data to save
        if !workouts.isEmpty {
            LocalStorage.shared.saveWorkouts(workouts)
        }
        if !completedWorkouts.isEmpty {
            LocalStorage.shared.saveCompletedWorkouts(completedWorkouts)
        }
        if !previousSets.isEmpty {
            LocalStorage.shared.savePreviousSets(previousSets)
        }
        print("DEBUG: Saved all data")
    }
    
    func addWorkout(_ workout: Workout) {
        workouts.append(workout)
    }
    
    func completeWorkout(_ workout: Workout) {
        var completedWorkout = workout
        completedWorkout.completionDate = Date()
        completedWorkouts.append(completedWorkout)
    }
    
    func addSet(exerciseId: UUID, set: WorkoutSet) {
        if previousSets[exerciseId] == nil {
            previousSets[exerciseId] = []
        }
        previousSets[exerciseId]?.append(set)
    }
}
