import Foundation
import SwiftUI

// MARK: - ProgressionStrategy
enum ProgressionStrategy: String, Codable {
    case weight = "Weight Increase"
    case reps = "Rep Increase"
    case both = "Weight and Rep Increase"
}

// MARK: - ProgressionSuggestion
struct ProgressionSuggestion: Codable, Identifiable {
    var id: UUID // Changed from 'let id = UUID()' to 'var id: UUID'
    let exerciseId: UUID
    let suggestedWeight: Double
    let suggestedReps: Int
    let message: String
    
    init(exerciseId: UUID, suggestedWeight: Double, suggestedReps: Int, message: String) {
        self.id = UUID() // Generate the ID in the initializer
        self.exerciseId = exerciseId
        self.suggestedWeight = suggestedWeight
        self.suggestedReps = suggestedReps
        self.message = message
    }
}

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
    // Added progression properties
    var progressionStrategy: ProgressionStrategy
    var lastProgressionDate: Date?
    var weightIncrement: Double
    var targetReps: Int
    
    init(name: String, sets: Int, restPeriod: Int, customRestPeriod: Int? = nil) {
        self.id = UUID()
        self.name = name
        self.sets = sets
        self.restPeriod = restPeriod
        self.customRestPeriod = customRestPeriod
        // Initialize progression properties with defaults
        self.progressionStrategy = .weight
        self.weightIncrement = 5.0
        self.targetReps = 8
        self.lastProgressionDate = nil
    }
}

// MARK: - WorkoutSet Model
struct WorkoutSet: Identifiable, Codable {
    let id: UUID
    var weight: Double
    var reps: Int
    let date: Date
    
    init(weight: Double, reps: Int) {
        self.id = UUID()
        self.weight = weight
        self.reps = reps
        self.date = Date()
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.weight = try container.decode(Double.self, forKey: .weight)
        self.reps = try container.decode(Int.self, forKey: .reps)
        self.date = try container.decode(Date.self, forKey: .date)
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
    
    @Published var progressionSuggestions: [UUID: ProgressionSuggestion] = [:] {
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
        let loadedProgressionSuggestions = LocalStorage.shared.loadProgressionSuggestions() // Add this line
        
        // Then assign to properties
        self.workouts = loadedWorkouts
        self.completedWorkouts = loadedCompletedWorkouts
        self.previousSets = loadedPreviousSets
        self.progressionSuggestions = loadedProgressionSuggestions // Add this line
        
        // Check for progressions after loading data
        checkProgressions()
        
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
        if !progressionSuggestions.isEmpty {  // Add this block
            LocalStorage.shared.saveProgressionSuggestions(progressionSuggestions)
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
        checkProgressions()
    }
    
    func addSet(exerciseId: UUID, set: WorkoutSet) {
        if previousSets[exerciseId] == nil {
            previousSets[exerciseId] = []
        }
        previousSets[exerciseId]?.append(set)
        checkProgressionForExercise(exerciseId: exerciseId)
    }
    
    // MARK: - Progression Methods
    func checkProgressions() {
        for workout in workouts {
            for day in workout.days {
                for exercise in day.exercises {
                    checkProgressionForExercise(exerciseId: exercise.id)
                }
            }
        }
    }
    
    private func checkProgressionForExercise(exerciseId: UUID) {
        guard let sets = previousSets[exerciseId],
              let exercise = findExercise(withId: exerciseId) else { return }
        
        let recentSets = getRecentSets(for: sets)
        if recentSets.count >= exercise.sets {
            if let suggestion = analyzeProgression(exercise: exercise, sets: recentSets) {
                progressionSuggestions[exerciseId] = suggestion
            }
        }
    }
    
    private func findExercise(withId id: UUID) -> Exercise? {
        for workout in workouts {
            for day in workout.days {
                if let exercise = day.exercises.first(where: { $0.id == id }) {
                    return exercise
                }
            }
        }
        return nil
    }
    
    private func getRecentSets(for sets: [WorkoutSet]) -> [WorkoutSet] {
        let sortedSets = sets.sorted(by: { $0.date > $1.date })
        guard let lastWorkoutDate = sortedSets.first?.date else { return [] }
        return sortedSets.filter {
            Calendar.current.isDate($0.date, inSameDayAs: lastWorkoutDate)
        }
    }
    
    private func analyzeProgression(exercise: Exercise, sets: [WorkoutSet]) -> ProgressionSuggestion? {
        let averageWeight = sets.map { $0.weight }.reduce(0, +) / Double(sets.count)
        let averageReps = sets.map { $0.reps }.reduce(0, +) / sets.count
        
        // Check if enough time has passed since last progression
        if let lastProgressionDate = exercise.lastProgressionDate {
            let daysSinceProgression = Calendar.current.dateComponents([.day], from: lastProgressionDate, to: Date()).day ?? 0
            if daysSinceProgression < 7 { return nil }
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
