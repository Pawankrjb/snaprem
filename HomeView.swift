import SwiftUI
import UIKit
struct CapturedPhoto: Identifiable {
    let id: UUID
    let image: UIImage
}
struct HomeView: View {
    @State private var showCamera = false
    @State private var capturedImage: CapturedPhoto?
    
    @EnvironmentObject var reminderStore: ReminderStore
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Snap Reminder")
                .font(.largeTitle)
                .bold()
            
            Text("Turn documents into reminders")
                .foregroundStyle(.secondary)
            
            Spacer()
            
            // Scan Card
            Button {
                showCamera = true
            } label: {
                VStack(spacing: 12) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 45))
                    
                    Text("Scan")
                        .font(.title2)
                        .bold()
                    
                    Text("Capture a document and create a reminder")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 220)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 24))
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            HStack {
                Text("Recent Reminders")
                    .font(.title2)
                    .bold()

                Spacer()
             
                if !reminderStore.reminders.isEmpty {
                    Button("See More") {
                        selectedTab = 3
                    }
                    .font(.subheadline)
                }
            }
            
            if reminderStore.reminders.isEmpty {
                Text("No reminders yet")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(reminderStore.reminders.prefix(3)) { reminder in
                    VStack(alignment: .leading) {
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
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            Spacer()
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraView(
                onImageCaptured: { image in
                    print("IMAGE CAPTURED:", image.size)
                    capturedImage = CapturedPhoto(id: UUID(), image: image)
                    showCamera = false
                },
                onCancel: {
                    showCamera = false
                }
            )
        }
        .fullScreenCover(item: $capturedImage) { photo in
            UploadView(
                initialImage: photo.image,
                selectedTab: $selectedTab
            )
                .environmentObject(reminderStore)
        }
        .padding()
    }
}

#Preview {
    HomeView(selectedTab: .constant(0))
        .environmentObject(ReminderStore())
}
