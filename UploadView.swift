import SwiftUI
import PhotosUI
import UIKit
import PDFKit
import Vision
import UserNotifications

struct UploadView: View {
    let initialImage: UIImage?
    let selectedTab: Binding<Int>
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showPhotoPicker = false
    @State private var showPDFPicker = false
    @State private var selectedPDF: URL?
    @State private var extractedText = ""
    @State private var detectedDate: String?
    @State private var detectedTime: String?
    @State private var finalDate = Date()
    @State private var showConfirmation = false
    @State private var showNoReminderFound = false
    @State private var showManualReminder = false
    @State private var manualReminderText = ""
    @State private var manualReminderDate = Date()
    @State private var candidateLines: [String] = []
    @State private var selectedCandidates: Set<String> = []
    @State private var isSettingReminder = false
    
    @EnvironmentObject var reminderStore: ReminderStore
    @Environment(\.dismiss) private var dismiss
    
    
    private let textRequest: VNRecognizeTextRequest = {
        
        let request = VNRecognizeTextRequest()
        
        request.recognitionLevel = .accurate
        
        return request
        
    }()
    
    func recognizeText(from image: UIImage) {
        
        
        extractedText = ""
        candidateLines = []
        selectedCandidates = []

        detectedDate = nil
        detectedTime = nil

        showConfirmation = false
        showNoReminderFound = false
        showManualReminder = false
        isSettingReminder = false
        print("Camera/Upload Image Received")
        print("CGImage:", image.cgImage != nil)
        guard let cgImage = image.cgImage else { return }
        let handler = VNImageRequestHandler(cgImage: cgImage)
        try? handler.perform([textRequest])
        if let results = textRequest.results {
            for result in results {
                if let text = result.topCandidates(1).first?.string {
                    extractedText+=text + "\n"
                    
                }
            }
            let detector = try? NSDataDetector(
                types: NSTextCheckingResult.CheckingType.date.rawValue
            )
            if let detector {
                let range = NSRange(
                    location: 0,
                    length: extractedText.utf16.count
                )
                
                let matches = detector.matches(
                    in: extractedText,
                    options: [],
                    range: range
                )
                for match in matches {
                    if  let date=match.date{
                        let text = (extractedText as NSString).substring(with: match.range)
                        if text.contains(":") {
                            detectedTime = text
                            print("Time:", text)
                        }
                        
                        if text.contains("-") {
                            detectedDate = text
                            print("Date:", text)
                        }
                    }
                }
                let lines = extractedText.components(separatedBy: .newlines)
                
                candidateLines = lines.filter { line in
                    let cleanLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    return !cleanLine.isEmpty &&
                    cleanLine != detectedDate &&
                    cleanLine != detectedTime
                }
                print("Candidates:", candidateLines)
                print("Detected Date:", detectedDate ?? "nil")
                print("Detected Time:", detectedTime ?? "nil")
                print("Extracted Text:", extractedText)
                guard let dateString = detectedDate,
                      let timeString = detectedTime else {
                    showNoReminderFound = true
                    return
                }
                
                let dateTimeString = "\(dateString) \(timeString)"
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy HH:mm"
                if let date = formatter.date(from: dateTimeString) {
                    finalDate = date
                    showConfirmation = true
                    print("DateTime:", date)
                    
                }
                
                
            }
        }
    }
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
    }
    func scheduleReminder(at date: Date, text: String, reminderID: UUID) {
        
        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: date
        )
        
        let content = UNMutableNotificationContent()
        content.title = "SnapReminder"
        content.body = text
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: components,
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: reminderID.uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print("Notification error:", error)
            } else {
                print("Notification scheduled")
            }
        }
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("Pending notifications:", requests.count)
            
            for request in requests {
                print("ID:", request.identifier)
                print("Trigger:", request.trigger ?? "No trigger")
            }
        }
    }
    
    
    
    var body: some View {
        VStack(spacing: 16) {
            ScrollView {
                Button {
                    showPhotoPicker = true
                }
                
                label: {
                    VStack(spacing: 10) {
                        Image(systemName: "photo")
                            .font(.system(size: 32))
                        
                        Text("Upload Image")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                }
                .buttonStyle(.bordered)
                .photosPicker(
                    isPresented: $showPhotoPicker,
                    selection: $selectedItem,
                    matching: .images
                )
//                if let selectedImage {
//                    Image(uiImage: selectedImage)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(height: 200)
//                }
//                
                
                
                Button {
                    showPDFPicker = true
                } label: {
                    VStack(spacing: 10) {
                        Image(systemName: "doc")
                            .font(.system(size: 32))
                        
                        Text("Upload PDF")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                }
                .buttonStyle(.bordered)
                if let selectedPDF {
                    PDFViewer(url: selectedPDF)
                        .frame(height: 300)
                }
              
                
                if showConfirmation {
                    Text(finalDate.formatted(date: .abbreviated, time: .shortened))
                        .font(.headline)
                }
                
                if showConfirmation{
                    VStack(spacing: 12) {
                        
                        Text("Reminder Found")
                            .font(.title2)
                            .bold()
                        ForEach(candidateLines.prefix(5), id: \.self) { line in
                            Toggle(
                                line,
                                isOn: Binding(
                                    get: {
                                        selectedCandidates.contains(line)
                                    },
                                    set: { isSelected in
                                        if isSelected {
                                            selectedCandidates.insert(line)
                                        } else {
                                            selectedCandidates.remove(line)
                                        }
                                    }
                                )
                            )
                        }
                        DatePicker(
                            "Reminder Time",
                            selection: $finalDate,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        Button("Cancel") {

                            showConfirmation = false

                            dismiss()
                        }

                        .buttonStyle(.bordered)
                        
                        Button("Set Reminder"){
                            guard !isSettingReminder else { return }

                               isSettingReminder = true
                            let reminderText = selectedCandidates.joined(separator: "\n")
                          
                            if reminderText.isEmpty {
                                isSettingReminder = false
                                print("Please select at least one reminder")
                                
                            } else {
                                let newReminder = Reminder(
                                    id: UUID(),
                                    text: reminderText,
                                    date: finalDate
                                )

                                reminderStore.reminders.append(newReminder)
                                reminderStore.selectedReminderID = newReminder.id
                                scheduleReminder(
                                    at: finalDate,
                                    text: reminderText,
                                    reminderID: newReminder.id
                                )
                                
                                showConfirmation = false
                                selectedTab.wrappedValue = 3
                                dismiss()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(isSettingReminder || finalDate <= Date() || selectedCandidates.isEmpty)
                        
                        .padding()
                    }
                    
                }
                if showNoReminderFound {
                    VStack(spacing: 16) {
                        
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary)
                        
                        Text("No Reminder Found")
                            .font(.title2)
                            .bold()
                        
                        Text("We couldn't find a date and time in this image. Please use a clearer image or enter the reminder manually.")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                        
                        Button("Enter Reminder Manually") {
                            isSettingReminder = false

                               manualReminderText = ""

                               manualReminderDate = Date()

                               showNoReminderFound = false

                               showManualReminder = true
                          
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button("Cancel") {
                            showNoReminderFound = false
                            dismiss()
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
                if showManualReminder {
                    VStack(spacing: 16) {
                        
                        Text("Enter Reminder")
                            .font(.title2)
                            .bold()
                        
                        TextField("Reminder text", text: $manualReminderText)
                            .textFieldStyle(.roundedBorder)
                        
                        DatePicker(
                            "Date & Time",
                            selection: $manualReminderDate,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        if manualReminderDate <= Date() {
                            Text("⚠️ Please select a future date and time.")
                                .font(.subheadline)
                                .foregroundStyle(.red)
                        }
                        Button("Set Reminder") {
                            guard !isSettingReminder else { return }
                            isSettingReminder = true
                            let text = manualReminderText.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            )
                            
                            if text.isEmpty {

                                isSettingReminder = false

                                print("Please enter reminder text")

                            } else {
                                let newReminder = Reminder(
                                    id: UUID(),
                                    text: text,
                                    date: manualReminderDate
                                )

                                reminderStore.reminders.append(newReminder)
                                reminderStore.selectedReminderID = newReminder.id

                                scheduleReminder(
                                    at: manualReminderDate,
                                    text: text,
                                    reminderID: newReminder.id
                                )

                                showManualReminder = false
                                selectedTab.wrappedValue = 3
                                dismiss()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(isSettingReminder || manualReminderDate <= Date())
                  
                        
                        
                        Button("Cancel") {
                          
                            showManualReminder = false
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                }
                
            }
            
            .onAppear {
                print("UPLOAD VIEW OPENED")

                   print("INITIAL IMAGE:", initialImage != nil)
                requestNotificationPermission()

                if let initialImage {
                    selectedImage = initialImage
                    recognizeText(from: initialImage)
                }
            }
            
            
            .onChange(of: selectedItem) {
                Task{
                    if let data=try? await selectedItem?.loadTransferable(type: Data.self){
                        selectedImage=UIImage(data: data)
                        recognizeText(from: selectedImage!)
                    }
                }
            }
            
            .padding()
            .fileImporter(
                isPresented: $showPDFPicker,
                allowedContentTypes: [.pdf]
            ) { result in
                switch result {
                case .success(let url):
                    selectedPDF = url
                    
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
    struct PDFViewer: UIViewRepresentable {
        
        let url: URL
        
        func makeUIView(context: Context) -> PDFView {
            
            PDFView()
            
        }
        
        func updateUIView(_ pdfView: PDFView, context: Context) {
            
            pdfView.document = PDFDocument(url: url)
            
        }
        
    }
}
#Preview {
    UploadView(
        initialImage: nil,
        selectedTab: .constant(0)
    )
    .environmentObject(ReminderStore())
}
