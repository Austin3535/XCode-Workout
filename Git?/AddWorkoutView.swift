import SwiftUI

struct AddWorkoutView: View {
    @EnvironmentObject var routine: Routine
    @Environment(\.presentationMode) var presentationMode
    @State private var workoutName = ""
    @State private var days: [Day] = []

    var body: some View {  // This is the required body property
        NavigationView {
            Form {
                Section(header: Text("Workout Name")) {
                    TextField("Enter workout name", text: $workoutName)
                }
                Section(header: Text("Days")) {
                    ForEach($days) { $day in
                        VStack(alignment: .leading) {
                            TextField("Day Name", text: $day.name)
                                .font(.headline)
                            ForEach($day.exercises) { $exercise in
                                VStack(alignment: .leading) {
                                    TextField("Exercise Name", text: $exercise.name)
                                    Stepper(value: $exercise.sets, in: 1...10) {
                                        Text("Sets: \(exercise.sets)")
                                    }
                                    Picker("Rest Period", selection: $exercise.restPeriod) {
                                        Text("1 min").tag(60)
                                        Text("2 min").tag(120)
                                        Text("5 min").tag(300)
                                        Text("Custom").tag(-1)
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                    if exercise.restPeriod == -1 {
                                        TextField("Custom Rest Period (seconds)",
                                                value: $exercise.customRestPeriod,
                                                formatter: NumberFormatter())
                                            .keyboardType(.numberPad)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                    }
                                }
                            }
                            Button(action: { addExercise(to: day) }) {
                                Text("Add Exercise")
                            }
                        }
                    }
                    .onDelete(perform: deleteDay)
                    Button(action: addDay) {
                        Text("Add Day")
                    }
                }
            }
            .navigationTitle("Create Workout")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveWorkout()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

    func addDay() {
        let newDay = Day(name: "", exercises: [])
        days.append(newDay)
    }

    func deleteDay(at offsets: IndexSet) {
        days.remove(atOffsets: offsets)
    }

    func addExercise(to day: Day) {
        if let index = days.firstIndex(where: { $0.id == day.id }) {
            days[index].exercises.append(Exercise(name: "", sets: 3, restPeriod: 120, customRestPeriod: nil))
        }
    }

    func saveWorkout() {
        let newWorkout = Workout(name: workoutName, days: days)
        routine.workouts.append(newWorkout)
    }
}

struct AddWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        AddWorkoutView()
            .environmentObject(Routine())
    }
}
