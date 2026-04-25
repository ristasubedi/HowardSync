//
//  SavedEventsView.swift
//  howardsync
//
//  Created by Aaryan Panthi on 4/25/26.
//

import SwiftUI

struct SavedEventsView: View {
    @State private var appState = AppState.shared
    @Environment(\.dismiss) private var dismiss
    
    private var savedEvents: [CampusEvent] {
        CampusEvent.sampleEvents.filter { appState.isEventSaved($0.id) }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if savedEvents.isEmpty {
                    emptyState
                } else {
                    List {
                        ForEach(savedEvents) { event in
                            NavigationLink(destination: EventDetailView(event: event)) {
                                savedEventRow(event)
                            }
                        }
                        .onDelete(perform: unsaveEvents)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Saved Events")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(HUTheme.bisonBlue)
                }
            }
        }
    }
    
    private func savedEventRow(_ event: CampusEvent) -> some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 10)
                .fill(event.color)
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: "heart.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.system(size: 16, weight: .semibold))
                
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 11))
                        Text(event.displayDate)
                            .font(.system(size: 12))
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "mappin")
                            .font(.system(size: 11))
                        Text(event.location)
                            .font(.system(size: 12))
                    }
                }
                .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(HUTheme.bisonRed.opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "heart.slash")
                    .font(.system(size: 36))
                    .foregroundColor(HUTheme.bisonRed.opacity(0.5))
            }
            
            Text("No Saved Events")
                .font(.system(size: 22, weight: .bold))
            
            Text("Heart events in the Bison Feed\nto save them here")
                .font(HUTheme.bodyFont)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(HUTheme.groupedBackground)
    }
    
    private func unsaveEvents(at offsets: IndexSet) {
        for index in offsets {
            let event = savedEvents[index]
            appState.toggleSaveEvent(event.id)
        }
    }
}

#Preview {
    SavedEventsView()
}
