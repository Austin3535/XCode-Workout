import SwiftUI

struct PreviousSetsView: View {
    let previousSets: [WorkoutSet]
    
    var body: some View {
        Section(header: Text("Previous Sets")) {
            ForEach(previousSets.suffix(3).reversed()) { set in
                HStack(spacing: 16) {
                    // Weight Circle
                    ZStack {
                        Circle()
                            .fill(Color(.systemGray6))
                            .frame(width: 50, height: 50)
                        
                        VStack(spacing: 0) {
                            Text("\(set.weight, specifier: "%.1f")")
                                .font(.system(size: 16, weight: .semibold))
                            Text("lbs")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("\(set.reps) reps")
                                .font(.system(.body, design: .rounded))
                                .fontWeight(.medium)
                        }
                        
                        Text(set.date.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 4)
            }
        }
        .padding(.top)
    }
}


//
//  PreviousSetsView.swift
//  Git?
//
//  Created by Austin Emfield on 12/4/24.
//

