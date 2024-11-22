import SwiftUI

struct PastWorkoutsView: View {
    @EnvironmentObject var routine: Routine

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("This Week")) {
                    ForEach(filteredWorkouts(for: .week)) { workout in
                        NavigationLink(destination: PastWorkoutDetailView(workout: workout)) {
                            workoutRow(workout)
                        }
                    }
                }
                Section(header: Text("This Month")) {
                    ForEach(filteredWorkouts(for: .month)) { workout in
                        NavigationLink(destination: PastWorkoutDetailView(workout: workout)) {
                            workoutRow(workout)
                        }
                    }
                }
                Section(header: Text("This Year")) {
                    ForEach(filteredWorkouts(for: .year)) { workout in
                        NavigationLink(destination: PastWorkoutDetailView(workout: workout)) {
                            workoutRow(workout)
                        }
                    }
                }
                Section(header: Text("Older")) {
                    ForEach(filteredWorkouts(for: .older)) { workout in
                        NavigationLink(destination: PastWorkoutDetailView(workout: workout)) {
                            workoutRow(workout)
                        }
                    }
                }
            }
            .navigationTitle("Past Workouts")
        }
    }

    private func filteredWorkouts(for period: TimePeriod) -> [Workout] {
        let now = Date()
        return routine.completedWorkouts.filter { workout in
            guard let date = workout.completionDate else { return false }
            switch period {
            case .week:
                return Calendar.current.isDate(date, equalTo: now, toGranularity: .weekOfYear)
            case .month:
                return Calendar.current.isDate(date, equalTo: now, toGranularity: .month)
            case .year:
                return Calendar.current.isDate(date, equalTo: now, toGranularity: .year)
            case .older:
                return !Calendar.current.isDate(date, equalTo: now, toGranularity: .year)
            }
        }
    }

    private func workoutRow(_ workout: Workout) -> some View {
        HStack {
            Text(workout.name)
            Spacer()
            if let day = workout.days.first {
                Text(day.name)
            }
            Spacer()
            if let date = workout.completionDate {
                Text("\(date, formatter: dateFormatter)")
            }
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }

    private enum TimePeriod {
        case week, month, year, older
    }
}

struct PastWorkoutsView_Previews: PreviewProvider {
    static var previews: some View {
        PastWorkoutsView()
            .environmentObject(Routine())
    }
}
