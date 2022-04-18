//
//  MediaManager.swift
//  Created by Krishna Soni on 18/04/22.
//

import Foundation
import UIKit
import Photos

final class MediaManager: NSObject {
    
    /// Shared(Singleton) object of MediaManager class.
    static let shared: MediaManager = MediaManager()
    var topMostViewController: UIViewController!
    
    private(set) lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        return imagePickerController
    }()
    
    private(set) var commpletion: ((_ image: UIImage?, _ info: [UIImagePickerController.InfoKey : Any]?) -> ())?
    
}

extension MediaManager {
    
    var allowsEditing: Bool {
        get {
            return imagePickerController.allowsEditing
        } set {
            imagePickerController.allowsEditing = newValue
        }
    }
}

extension MediaManager {
    
    func openGallery(view: UIViewController, isEditing: Bool = false, commpletion: ((_ image: UIImage?, _ info: [UIImagePickerController.InfoKey : Any]?) -> ())?) {
        
        topMostViewController = view
        self.allowsEditing = isEditing
        takeAPhotoGallery()
        self.commpletion = commpletion
    }
    
    /// A private method used to select an image from camera.
    private func takeAPhotoGallery() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else{
            print("Your device doesn't support camera.")
            return
        }
        
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        topMostViewController?.present(imagePickerController, animated: true, completion: nil)
    }
}

// MARK:- ImagePicker Delegate -
extension MediaManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true) { [weak self] in
            
            guard let self = self, let commpletion = self.commpletion else {
                return
            }
            
            var image:UIImage?
            if (self.allowsEditing) {
                image = info[.editedImage] as? UIImage
            } else {
                image = info[.originalImage] as? UIImage
            }
            
            commpletion(image, info)
        }
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true) { [weak self] in
            
            guard let self = self, let commpletion = self.commpletion else {
                return
            }
            commpletion(nil, nil)
        }
    }
}


