//
//  AWSManager.swift
//  AWS-Face-Rekognition
//
//  Created by Krishna Soni on 18/04/22.
//

import Foundation
import AWSRekognition

final class AWSManager {
    
    private static var awsManager: AWSManager = {
        let awsManager = AWSManager()
        return awsManager
    }()
    
    static func shared() -> AWSManager {
        return awsManager
    }
    
    private var credentialsProvider: AWSStaticCredentialsProvider?
    private var compareFacesRequest: AWSRekognitionCompareFacesRequest?
    private let key = "demoFaceimage"
}

extension AWSManager {
    func configureAWS() {
        
        if (credentialsProvider == nil) {
            credentialsProvider = AWSStaticCredentialsProvider(accessKey: "<---YOUR ACCESS KEY --->", secretKey:"<--- YOUR SECRETKEY --->")
            let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
            AWSServiceManager.default().defaultServiceConfiguration = configuration
            AWSRekognition.register(with: configuration!, forKey: key)
        }
        
        // If request is empty
        if (compareFacesRequest == nil) {
            guard let request = AWSRekognitionCompareFacesRequest() else {
                puts("Unable to initialize AWSRekognitionDetectLabelsRequest.")
                return
            }
            
            compareFacesRequest = request
        }
    }
}

// MARK: - AWS Face comparation methods -
extension AWSManager {
    
    func faceCompareRequest(targetImage: UIImage?, sourceImage: UIImage?, completion: @escaping ((_ respone: AWSRekognitionCompareFacesResponse?, _ error: Error?)->Void)) {
        
        let rekognition = AWSRekognition(forKey: key)
        
        guard let `compareFacesRequest` = compareFacesRequest else {
            return
        }
        
        
        guard let mySourceImage = sourceImage,
              let awsSourceImage = AWSRekognitionImage() else {
            return
        }
        
        awsSourceImage.bytes = mySourceImage.jpegData(compressionQuality: 0.7)// Specify your source image
        compareFacesRequest.sourceImage = awsSourceImage
        
        
        // This is the target image which we need to compare
        guard let myTargetImage = targetImage else {
            return
        }
        
        let targetImage = AWSRekognitionImage()
        targetImage!.bytes = myTargetImage.jpegData(compressionQuality: 0.7) // Specify your target image
        compareFacesRequest.targetImage = targetImage
        
        rekognition.compareFaces(compareFacesRequest) { [weak self] (response, error) in
            
            guard let _ = self else {
                return
            }
            if error == nil {
                if let `response` = response {
                    completion(response, nil);
                }
            } else {
                
                completion(nil, error);
            }
            
        }
    }
    
    
}
