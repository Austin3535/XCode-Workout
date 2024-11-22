import Foundation
import SwiftUI

struct Workout: Identifiable, Codable {
    var id: UUID
    var name: String       // Changed from let to var
    var days: [Day]       // Changed from let to var
    var completionDate: Date?
    
    init(name: String, days: [Day]) {
        self.id = UUID()
        self.name = name
        self.days = days
        self.completionDate = nil
    }
}

struct Day: Identifiable, Codable {
    var id: UUID
    var name: String      // Changed from let to var
    var exercises: [Exercise]  // Changed from let to var
    
    init(name: String, exercises: [Exercise]) {
        self.id = UUID()
        self.name = name
        self.exercises = exercises
    }
}

struct Exercise: Identifiable, Codable {
    var id: UUID
    var name: String      // Changed from let to var
    var sets: Int        // Changed from let to var
    var restPeriod: Int  // Changed from let to var
    var customRestPeriod: Int?  // Changed from let to var
    
    init(name: String, sets: Int, restPeriod: Int, customRestPeriod: Int? = nil) {
        self.id = UUID()
        self.name = name
        self.sets = sets
        self.restPeriod = restPeriod
        self.customRestPeriod = customRestPeriod
    }
}

struct WorkoutSet: Identifiable, Codable {
    var id: UUID         // This can stay let since it's an identifier
    var weight: Double   // Changed from let to var
    var reps: Int       // Changed from let to var
    var date: Date      // This can stay let since it's set once at creation
    
    init(weight: Double, reps: Int) {
        self.id = UUID()
        self.weight = weight
        self.reps = reps
        self.date = Date()
    }
}
class Routine: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var completedWorkouts: [Workout] = []
    @Published var previousSets: [UUID: [WorkoutSet]] = [:]
    
    init() {
        loadData()
    }
    
    private func loadData() {
        workouts = LocalStorage.shared.loadWorkouts()
        completedWorkouts = LocalStorage.shared.loadCompletedWorkouts()
        previousSets = LocalStorage.shared.loadPreviousSets()
    }
    
    func addWorkout(_ workout: Workout) {
        workouts.append(workout)
        saveData()
    }
    
    func completeWorkout(_ workout: Workout) {
        var completedWorkout = workout
        completedWorkout.completionDate = Date()
        completedWorkouts.append(completedWorkout)
        saveData()
    }
    
    func addSet(exerciseId: UUID, set: WorkoutSet) {
        if previousSets[exerciseId] == nil {
            previousSets[exerciseId] = []
        }
        previousSets[exerciseId]?.append(set)
        saveData()
    }
    
    private func saveData() {
        LocalStorage.shared.saveWorkouts(workouts)
        LocalStorage.shared.saveCompletedWorkouts(completedWorkouts)
        LocalStorage.shared.savePreviousSets(previousSets)
    }
}
