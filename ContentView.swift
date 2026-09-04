//
//  ContentView.swift
//  SnapReminder
//
//  Created by Pawan on 29/08/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var reminderStore = ReminderStore()
    @State private var selectedTab = 0
    var body: some View {
        
      
        
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Color.black
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            UploadView(
                initialImage: nil,
                selectedTab: $selectedTab
            )
                .tabItem {
                    Label("Upload", systemImage: "arrow.up.circle")
                }
                .tag(1)
            Catagory()
                .tabItem {
                    Label("Catagory",systemImage: "square.grid.2x2")
                }
                .tag(2)
            RemindersView()
            
                .tabItem {
                    Label("Reminders", systemImage: "bell.fill")
                }
                .tag(3)
            Documents()
                .tabItem {
                    Label("Documents", systemImage: "doc.fill")
                }
                .tag(4)
                
          
        }
        .environmentObject(reminderStore)
    }
    
}

