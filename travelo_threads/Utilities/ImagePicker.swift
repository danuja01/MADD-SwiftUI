//
//  ImagePicker.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-10.
//

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType
    var imageName: Binding<String?>? = nil

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self, imageName: imageName)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        var imageName: Binding<String?>?

        init(_ parent: ImagePicker, imageName: Binding<String?>?) {
            self.parent = parent
            self.imageName = imageName
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
                if let imageNameBinding = imageName {
                    if let url = info[.imageURL] as? URL {
                        imageNameBinding.wrappedValue = url.lastPathComponent
                    } else {
                        imageNameBinding.wrappedValue = "CapturedPhoto.jpg"
                    }
                }
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
