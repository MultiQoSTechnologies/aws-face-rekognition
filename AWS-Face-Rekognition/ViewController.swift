//
//  ViewController.swift
//  AWS-Face-Rekognition
//
//  Created by Krishna Soni on 18/04/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imgFirst: UIImageView!
    @IBOutlet weak var imgSecond: UIImageView!
    @IBOutlet weak var lblResult: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: - Action Events -
extension ViewController {
    
    @IBAction func btnSelectClick(_ sender: UIButton) {
        
        if (sender.tag == 0) {
            MediaManager.shared.openGallery(view: self) {[weak self] (image, info) in
            
                guard let `self` = self,
                 let `image` = image else {
                    return
                }
                
                self.imgFirst.image = image
            }
            
        }else {
            MediaManager.shared.openGallery(view: self) {[weak self] (image, info) in
            
                guard let `self` = self,
                 let `image` = image else {
                    return
                }
                
                self.imgSecond.image = image
            }
        }
    }
    
    @IBAction func btnCompareClick(_ sender: UIButton) {
        /// Configure AWS
        AWSManager.shared().configureAWS()
        
        lblResult.text = "comparing..."
        AWSManager.shared().faceCompareRequest(targetImage: imgFirst.image, sourceImage: imgSecond.image) { [weak self] (response, error) in
            
            guard let `self` = self else {
                return
            }
            
            if let `response` = response {
                
                if let match = response.faceMatches?.first {
                    DispatchQueue.main.async {
                        self.lblResult.text = "Matched!\nSimilarity: \(match.similarity ?? 0.0)"
                    }
                } else {
                    DispatchQueue.main.async {
                        self.lblResult.text = "Sorry!\nNot Matched"
                    }
                }
                
            }else {
                print("error = \(error?.localizedDescription ?? "")")
                DispatchQueue.main.async {
                    self.lblResult.text = error?.localizedDescription ?? ""
                }
            }
        }
        
    }
    
}

