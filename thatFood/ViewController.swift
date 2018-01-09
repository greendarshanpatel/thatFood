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
import Alamofire
import SwiftyJSON


class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var resultToBePassed: String?
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
   
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
    
    
    
    
    //MARK: making function that detects image data with machine learning model
    //
    func detect(image: CIImage){
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("loading coreml model failed!")
        }
        
        let request = VNCoreMLRequest(model: model){(request, Error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("model failed to prossess")
            }
            self.resultToBePassed = String(describing: (results.first?.identifier)!)
             self.performSegue(withIdentifier:"mainToDetailSegue", sender: self)
            self.title = results.first?.identifier.capitalized
            self.requestInfo(flowerName: self.title!)
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do{
            try handler.perform([request])
        }
        catch{
            print(error)
        }
       
    }
    
    //MARK: making http request
    
    func requestInfo(flowerName: String){
    let wikipediaURl = "https://en.wikipedia.org/w/api.php"
    
    let parameters : [String:String] = [
        "format" : "json",
        "action" : "query",
        "prop" : "extracts",
        "exintro" : "",
        "explaintext" : "",
         "titles" : flowerName,
        "indexpageids" : "",
        "redirects" : "1",
    ]
        Alamofire.request(wikipediaURl, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess{
                print(response)
            }
        }
        
    }
    
    
    
    
    
    
    
    //MARK: preparing for segue
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "mainToDetailSegue"{
//        let goDetail: String = resultToBePassed!
//        if let destinationViewController = segue.destination as? detailViewController {
//            destinationViewController.data = goDetail
//        }
//        }
//    }
    //MARK: making a function that authonticate user
    func authenticateUser() {
        let authContext : LAContext = LAContext()
        var error: NSError?
        
        if authContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error){
            authContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Biometric Check for application", reply: {successful, error -> Void in
                if successful{
                    print("TouchID Yes")
                }
                else{
                   // this point application should get teminated
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
                    // this point application should get teminated
                    print("PassCode No")
                }
            }
            )
        }
    }
    
    
    
}

