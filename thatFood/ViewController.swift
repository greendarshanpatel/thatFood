//
//  ViewController.swift
//  thatFood
//
//  Created by Darshan Patel on 26/12/17.
//  Copyright © 2017 Darshan Patel. All rights reserved.
//

import UIKit
import CoreML
import Vision
import LocalAuthentication


class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        authenticateUser()
       
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = userPickedImage
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("couldn't convert uiimage in ciimage")
            }
            detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func detect(image: CIImage){
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("loading coreml model failed!")
        }
        
        let request = VNCoreMLRequest(model: model){(request, Error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("model failed to prossess")
            }
            self.label.text = String(describing: (results.first?.identifier)! + String(describing: results.first?.confidence))
            print(self.label.text as Any)
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do{
            try handler.perform([request])
        }
        catch{
            print(error)
        }
    }
    
    func authenticateUser() {
        let authContext : LAContext = LAContext()
        var error: NSError?
        
        if authContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error){
            authContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Biometric Check for application", reply: {successful, error -> Void in
                if successful{
                    print("TouchID Yes")
                }
                else{
        
                    print("TouchID No")
                }
            }
            )
        }
        else{
            authContext.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: "Enter your Passcode", reply: {
                successful,error in
                if successful{
                    print("PassCode Yes")
                }
                else{
                    print("PassCode No")
                }
            }
            )
        }
    }
    
    
    
}

