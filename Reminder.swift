//
//  Remainders.swift
//  SnapReminder
//
//  Created by Pawan on 29/08/26.
//
import SwiftUI
import Foundation
import Combine
import UserNotifications

class ReminderStore: ObservableObject {
    @Published var selectedReminderID: UUID?
    @Published var reminders: [Reminder] = [] {
        didSet {
            saveReminders()
        }
    }

    private let key = "savedReminders"

    init() {
        loadReminders()
    }
        func deleteReminder(_ reminder: Reminder) {
            reminders.removeAll {
                $0.id == reminder.id
            }

            UNUserNotificationCenter.current()
                .removePendingNotificationRequests(
                    withIdentifiers: [reminder.id.uuidString]
                )
        }
        func deleteAllReminders() {
            let ids = reminders.map {
                $0.id.uuidString
            }

            reminders.removeAll()
            selectedReminderID = nil

            UNUserNotificationCenter.current()
                .removePendingNotificationRequests(
                    withIdentifiers: ids
                )
        }
        
    

    private func saveReminders() {
        if let data = try? JSONEncoder().encode(reminders) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func loadReminders() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let savedReminders = try? JSONDecoder().decode(
                [Reminder].self,
                from: data
              ) else {
            return
        }

        reminders = savedReminders
    }
}

struct Reminder: Identifiable, Codable {
    let id :UUID
      let text: String
   let  date: Date
}

struct RemindersView: View {
    @EnvironmentObject var reminderStore: ReminderStore
    @State private var showClearAlert = false

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                List(reminderStore.reminders) { reminder in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(reminder.text)
                            .font(.headline)

                        Text(
                            reminder.date.formatted(
                                date: .abbreviated,
                                time: .shortened
                            )
                        )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            reminderStore.deleteReminder(reminder)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .id(reminder.id)
                }
                .navigationTitle("Reminders")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Clear") {
                            showClearAlert = true
                        }
                        
                    }
                }
                .alert("Clear All Reminders?", isPresented: $showClearAlert) {
                    Button("Cancel", role: .cancel) {
                        
                    }

                    Button("Clear All", role: .destructive) {
                        reminderStore.deleteAllReminders()
                    }
                } message: {
                    Text("Are you sure you want to delete all reminders?")
                }
                .onAppear {
                    if let id = reminderStore.selectedReminderID {
                        DispatchQueue.main.async {
                            proxy.scrollTo(id, anchor: .center)
                        }
                    }
                }
            }
        }
    }
}
