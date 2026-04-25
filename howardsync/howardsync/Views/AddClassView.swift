//
//  AddClassView.swift
//  howardsync
//
//  Created by Aaryan Panthi on 4/25/26.
//

import SwiftUI

struct AddClassView: View {
    enum Mode: Identifiable {
        case add
        case edit(ClassSchedule)
        
        var id: String {
            switch self {
            case .add: return "add"
            case .edit(let c): return c.id
            }
        }
    }
    
    let mode: Mode
    @Environment(\.dismiss) private var dismiss
    @State private var appState = AppState.shared
    
    @State private var courseName = ""
    @State private var courseCode = ""
    @State private var startTime = "9:00 AM"
    @State private var endTime = "10:30 AM"
    @State private var building = ""
    @State private var roomNumber = ""
    @State private var professorName = ""
    @State private var selectedDays: Set<String> = []
    @State private var showValidation = false
    
    private let allDays = ["Mon", "Tue", "Wed", "Thu", "Fri"]
    private let timeOptions = [
        "7:00 AM", "7:30 AM", "8:00 AM", "8:30 AM",
        "9:00 AM", "9:30 AM", "10:00 AM", "10:30 AM",
        "11:00 AM", "11:30 AM", "12:00 PM", "12:30 PM",
        "1:00 PM", "1:30 PM", "2:00 PM", "2:30 PM",
        "3:00 PM", "3:30 PM", "4:00 PM", "4:30 PM",
        "5:00 PM", "5:30 PM", "6:00 PM", "6:30 PM",
        "7:00 PM", "7:30 PM", "8:00 PM"
    ]
    
    private var isEditing: Bool {
        if case .edit = mode { return true }
        return false
    }
    
    private var title: String {
        isEditing ? "Edit Class" : "Add Class"
    }
    
    private var isValid: Bool {
        !courseName.isEmpty && !courseCode.isEmpty && !building.isEmpty &&
        !roomNumber.isEmpty && !selectedDays.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // Course Info
                Section("Course Information") {
                    TextField("Course Name", text: $courseName)
                    TextField("Course Code (e.g. CSCI 201)", text: $courseCode)
                        .autocapitalization(.allCharacters)
                    TextField("Professor Name", text: $professorName)
                }
                
                // Location
                Section("Location") {
                    TextField("Building", text: $building)
                    TextField("Room Number", text: $roomNumber)
                        .keyboardType(.numberPad)
                }
                
                // Time
                Section("Schedule") {
                    Picker("Start Time", selection: $startTime) {
                        ForEach(timeOptions, id: \.self) { time in
                            Text(time).tag(time)
                        }
                    }
                    
                    Picker("End Time", selection: $endTime) {
                        ForEach(timeOptions, id: \.self) { time in
                            Text(time).tag(time)
                        }
                    }
                }
                
                // Days
                Section("Days") {
                    HStack(spacing: 8) {
                        ForEach(allDays, id: \.self) { day in
                            Button {
                                if selectedDays.contains(day) {
                                    selectedDays.remove(day)
                                } else {
                                    selectedDays.insert(day)
                                }
                            } label: {
                                Text(day)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(selectedDays.contains(day) ? .white : .primary)
                                    .frame(width: 44, height: 44)
                                    .background(
                                        selectedDays.contains(day) ? HUTheme.bisonBlue : Color(UIColor.systemGray5)
                                    )
                                    .clipShape(Circle())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 4)
                    
                    if showValidation && selectedDays.isEmpty {
                        Text("Please select at least one day")
                            .font(.system(size: 13))
                            .foregroundColor(HUTheme.bisonRed)
                    }
                }
                
                // Validation
                if showValidation && !isValid {
                    Section {
                        Label("Please fill in all required fields", systemImage: "exclamationmark.triangle")
                            .foregroundColor(HUTheme.bisonRed)
                            .font(.system(size: 14))
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.secondary)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(isEditing ? "Save" : "Add") {
                        showValidation = true
                        guard isValid else { return }
                        
                        let sortedDays = allDays.filter { selectedDays.contains($0) }
                        
                        if case .edit(let existing) = mode {
                            let updated = ClassSchedule(
                                id: existing.id,
                                courseName: courseName,
                                courseCode: courseCode,
                                startTime: startTime,
                                endTime: endTime,
                                building: building,
                                roomNumber: roomNumber,
                                professorName: professorName,
                                dayOfWeek: sortedDays
                            )
                            appState.updateClass(updated)
                        } else {
                            let newClass = ClassSchedule.create(
                                courseName: courseName,
                                courseCode: courseCode,
                                startTime: startTime,
                                endTime: endTime,
                                building: building,
                                roomNumber: roomNumber,
                                professorName: professorName,
                                dayOfWeek: sortedDays
                            )
                            appState.addClass(newClass)
                        }
                        
                        // Schedule notifications for updated schedule
                        NotificationService.shared.scheduleClassReminders(for: appState.classSchedule)
                        
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(HUTheme.bisonBlue)
                }
            }
            .onAppear {
                if case .edit(let classItem) = mode {
                    courseName = classItem.courseName
                    courseCode = classItem.courseCode
                    startTime = classItem.startTime
                    endTime = classItem.endTime
                    building = classItem.building
                    roomNumber = classItem.roomNumber
                    professorName = classItem.professorName
                    selectedDays = Set(classItem.dayOfWeek)
                }
            }
        }
    }
}

#Preview {
    AddClassView(mode: .add)
}
