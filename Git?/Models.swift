// Models.swift
import SwiftUI

struct Exercise: Identifiable {
    let id = UUID()
    var name: String
    var sets: Int
    var restPeriod: Int
    var customRestPeriod: Int?
}

struct Set: Identifiable {
    let id = UUID()
    var reps: Int
    var weight: Double
    var date: Date
}

struct Day: Identifiable {
    let id = UUID()
    var name: String
    var exercises: [Exercise]
}

struct Workout: Identifiable {
    let id = UUID()
    var name: String
    var days: [Day]
    var completionDate: Date? = nil
}

class Routine: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var previousSets: [UUID: [Set]] = [:]
    @Published var completedWorkouts: [Workout] = []
}//

