//
//  CameraView.swift
//  SnapReminder
//
//  Created by Pawan on 01/09/26.
//
import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {
    
    let onImageCaptured: (UIImage) -> Void
    let onCancel: () -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        
        picker.sourceType = .camera
        picker.allowsEditing = false
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(
        _ uiViewController: UIImagePickerController,
        context: Context
    ) {
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImageCaptured(image)
            }
            
            parent.onCancel()
        }
        
        func imagePickerControllerDidCancel(
            _ picker: UIImagePickerController
        ) {
            parent.onCancel()
        }
    }
}
