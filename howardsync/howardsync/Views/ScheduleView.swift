//
//  ScheduleView.swift
//  howardsync
//
//  Created by Aaryan Panthi on 4/25/26.
//

import SwiftUI

struct ScheduleView: View {
    @State private var appState = AppState.shared
    @State private var showAddClass = false
    @State private var editingClass: ClassSchedule?
    @Environment(\.dismiss) private var dismiss
    
    private let dayOrder = ["Mon", "Tue", "Wed", "Thu", "Fri"]
    
    private var groupedSchedule: [(String, [ClassSchedule])] {
        var grouped: [String: [ClassSchedule]] = [:]
        for day in dayOrder {
            let classes = appState.classSchedule.filter { $0.dayOfWeek.contains(day) }
            if !classes.isEmpty {
                grouped[day] = classes.sorted { $0.startTime < $1.startTime }
            }
        }
        return dayOrder.compactMap { day in
            guard let classes = grouped[day] else { return nil }
            return (day, classes)
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if appState.classSchedule.isEmpty {
                    emptyState
                } else {
                    List {
                        ForEach(groupedSchedule, id: \.0) { day, classes in
                            Section {
                                ForEach(classes) { classItem in
                                    classRow(classItem)
                                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                            Button(role: .destructive) {
                                                withAnimation {
                                                    appState.deleteClass(id: classItem.id)
                                                }
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                        .swipeActions(edge: .leading) {
                                            Button {
                                                editingClass = classItem
                                            } label: {
                                                Label("Edit", systemImage: "pencil")
                                            }
                                            .tint(HUTheme.bisonBlue)
                                        }
                                        .onTapGesture {
                                            editingClass = classItem
                                        }
                                }
                            } header: {
                                Text(fullDayName(day))
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(HUTheme.bisonBlue)
                                    .textCase(nil)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("My Schedule")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Done") { dismiss() }
                        .foregroundColor(HUTheme.bisonBlue)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddClass = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(HUTheme.bisonBlue)
                    }
                }
            }
            .sheet(isPresented: $showAddClass) {
                AddClassView(mode: .add)
            }
            .sheet(item: $editingClass) { classItem in
                AddClassView(mode: .edit(classItem))
            }
        }
    }
    
    private func classRow(_ classItem: ClassSchedule) -> some View {
        HStack(spacing: 14) {
            // Time indicator
            VStack(spacing: 2) {
                Text(classItem.startTime)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(HUTheme.bisonBlue)
                
                Rectangle()
                    .fill(HUTheme.bisonBlue.opacity(0.3))
                    .frame(width: 1, height: 12)
                
                Text(classItem.endTime)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .frame(width: 65)
            
            // Color accent bar
            RoundedRectangle(cornerRadius: 3)
                .fill(HUTheme.bisonBlue)
                .frame(width: 4, height: 50)
            
            // Class info
            VStack(alignment: .leading, spacing: 4) {
                Text(classItem.courseCode)
                    .font(.system(size: 16, weight: .bold))
                
                Text(classItem.courseName)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "mappin")
                            .font(.system(size: 10))
                        Text(classItem.locationString)
                            .font(.system(size: 12))
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "person")
                            .font(.system(size: 10))
                        Text(classItem.professorName)
                            .font(.system(size: 12))
                    }
                }
                .foregroundColor(.secondary.opacity(0.8))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary.opacity(0.3))
        }
        .padding(.vertical, 4)
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(HUTheme.bisonBlue.opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "calendar.badge.plus")
                    .font(.system(size: 36))
                    .foregroundColor(HUTheme.bisonBlue.opacity(0.5))
            }
            
            Text("No Classes Yet")
                .font(.system(size: 22, weight: .bold))
            
            Text("Tap + to add your first class")
                .font(HUTheme.bodyFont)
                .foregroundColor(.secondary)
            
            Button {
                showAddClass = true
            } label: {
                Text("Add Class")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(HUTheme.bisonBlue)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(HUTheme.groupedBackground)
    }
    
    private func fullDayName(_ abbreviation: String) -> String {
        switch abbreviation {
        case "Mon": return "Monday"
        case "Tue": return "Tuesday"
        case "Wed": return "Wednesday"
        case "Thu": return "Thursday"
        case "Fri": return "Friday"
        default: return abbreviation
        }
    }
}

#Preview {
    ScheduleView()
}
