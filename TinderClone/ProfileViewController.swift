//
//  ProfileViewController.swift
//  TinderClone
//
//  Created by Connor Miller on 12/27/18.
//  Copyright © 2018 Connor Miller. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userGenderSwitch: UISwitch!
    @IBOutlet weak var genderInterestSwitch: UISwitch!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        createWomen()
        
        errorLabel.isHidden = true
        
        if let photo = PFUser.current()?["profileImage"] as? PFFileObject {
            
            photo.getDataInBackground { (data, error) in
                
                if let imageData = data {
                    
                    if let image = UIImage(data: imageData) {
                        
                        self.profileImageView.image = image
                        
                    }
                    
                }
                
            }
            
        }
        
        if let isFemale = PFUser.current()?["isFemale"] as? Bool {
            
            userGenderSwitch.setOn(isFemale, animated: false)
            
        }
        
        if let isInterestedInWomen = PFUser.current()?["isInterestedInWomen"] as? Bool {
            
            genderInterestSwitch.setOn(isInterestedInWomen, animated: false)
            
        }
    }
    
    @IBAction func updateImage(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            profileImageView.image = image
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func update(_ sender: Any) {
        
        PFUser.current()?["isFemale"] = userGenderSwitch.isOn
        PFUser.current()?["isInterestedInWomen"] = genderInterestSwitch.isOn
        
        if let image = profileImageView.image {
            
            if let imageData = image.pngData() {
                
                PFUser.current()?["profileImage"] = PFFileObject(name: "profile.png", data: imageData)
                
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    
                    if error != nil {
                        
                        var errorMessage = "Update Failed - Try Again"
                        
                        if let newError = error as NSError? {
                            
                            if let detailError = newError.userInfo["error"] as? String {
                                
                                errorMessage = detailError
                                
                            }
                            
                        }
                        
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = errorMessage
                        
                    } else {
                        
                        print("Update Successful")
                        self.performSegue(withIdentifier: "updateToSwipeSegue", sender: nil)
                        
                    }
                    
                })
                
            }
            
        }
        
    }
    
    func createWomen() {
        
        let imageUrls = [
            "https://vignette.wikia.nocookie.net/simpsons/images/6/6f/Titania_%28Official_Image%29.png/revision/latest?cb=20120330175037",
            "https://upload.wikimedia.org/wikipedia/en/thumb/7/76/Edna_Krabappel.png/220px-Edna_Krabappel.png",
            "https://s3.amazonaws.com/pq-imgs/images/quizzes/marge-simpson.jpg-2643.jpg",
            "https://vignette.wikia.nocookie.net/simpsons/images/c/c9/Sara_Sloane.png/revision/latest?cb=20100708193925",
            "https://vg-images.condecdn.net/image/5BMYxb0n56D/crop/405/f/simpsons9_v_17may2010_alexsandropalombo_b_1.jpg",
            "https://flavorwire.files.wordpress.com/2013/07/got3.jpg",
            "https://www.seoclerk.com/pics/204619-1PaWRs1396927586.png"
        ]
        
        var counter = 0
        
        for imageUrl in imageUrls {
            
            if let url = URL(string: imageUrl) {
                
                if let data = try? Data(contentsOf: url) {
                    
                    let imageFile = PFFileObject(name: "profile.png", data: data)
                    
                    let user = PFUser()
                    
                    counter += 1
                    
                    user["profileImage"] = imageFile
                    user["username"] = String(counter)
                    user["password"] = "pass"
                    user["isFemale"] = true
                    user["isInterestedInWomen"] = false
                    
                    user.signUpInBackground { (success, error) in
                        
                        if success {
                            
                            print("Women created!")
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
    }
    
}
