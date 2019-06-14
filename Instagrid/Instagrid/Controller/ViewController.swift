//
//  ViewController.swift
//  Instagrid
//
//  Created by Mélanie Obringer on 18/04/2019.
//  Copyright © 2019 Mélanie Obringer. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    // Connect outlet for dispositionView
    @IBOutlet weak var dispositionView: DispositionView!
    // Connect outlets for buttons
    @IBOutlet weak var leftTop: UIImageView!
    @IBOutlet weak var rightTop: UIImageView!
    @IBOutlet weak var leftBottom: UIImageView!
    @IBOutlet weak var rightBottom: UIImageView!
    // Connect outlets for swipe up/left when the device is rotated 
    @IBOutlet weak var swipeUp: UISwipeGestureRecognizer!
    @IBOutlet weak var swipeLeft: UISwipeGestureRecognizer!
    
    // Properties
    let pickerController = UIImagePickerController()
    var selectedImage:  UIImageView?
    var screenshot : UIImage?
    
    // Method for swipeGesture when device is rotated
    @IBAction func swipeOrientation(_ sender: UISwipeGestureRecognizer) {
        if (UIDevice.current.orientation.isLandscape  && sender.direction == .left) || (UIDevice.current.orientation.isPortrait && sender.direction == .up) {
            shareGrid()
        }
    }
    
    // Method for gesture when user want to tap on button to add a photo
    func tapGestureRecognizer() {
        leftTop.isUserInteractionEnabled = true
        leftTop.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addPhoto)))
        
        rightTop.isUserInteractionEnabled = true
        rightTop.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addPhoto)))
        
        leftBottom.isUserInteractionEnabled = true
        leftBottom.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addPhoto)))
        
        rightBottom.isUserInteractionEnabled = true
        rightBottom.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addPhoto)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dispositionView.backgroundColor = #colorLiteral(red: 0.1563128829, green: 0.4470875859, blue: 0.6286138892, alpha: 1)
        dispositionView.style = .layoutThree
        tapGestureRecognizer()
        dispositionView.isUserInteractionEnabled = true
        //shareGrid()
    }
    
    // Connect outlet with text label to change
    @IBOutlet weak var swipeLabel: UILabel!
    // Method to change text label when the device is rotated
    override func viewWillLayoutSubviews() {
        let orientation = UIDevice.current.orientation
        switch orientation {
        case .landscapeLeft:
            swipeLabel.text = "Swipe left to share"
        case .landscapeRight:
            swipeLabel.text = "Swipe left to share"
        case .portrait:
            swipeLabel.text = "Swipe up to share"
        default :
            break
        }
    }
    
    // Methodes to add photo from library
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage: UIImage = (info[.originalImage] as! UIImage)
        self.selectedImage?.image = selectedImage
        self.selectedImage?.contentMode = .scaleToFill
        dismiss(animated: true, completion: nil)
    }
    // Method when user cancel to access to the library
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        selectedImage?.contentMode = .center
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Method when user selected a picture from the library
    @objc fileprivate func addPhoto(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = .overCurrentContext
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        if sender.state != .ended { return }
        selectedImage = sender.view as? UIImageView
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // Method to share the grid if it's full with animation and reset at the end
    func shareGrid(){
        if pictureViewIsFull() == true { // check if the grid is full before
            UIGraphicsBeginImageContext(dispositionView.frame.size) // create screenshot
            dispositionView.layer.render(in: UIGraphicsGetCurrentContext()!)
            screenshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let share = UIActivityViewController(activityItems: [screenshot as Any], applicationActivities: nil) // propertie to share the grid
            present(share, animated: true, completion: nil)
            if UIDevice.current.orientation.isPortrait {
                self.animatePortrait()
                share.completionWithItemsHandler = { (UIActivityType: UIActivity.ActivityType?, completed: Bool, returnItems: [Any]?, error: Error?) in
                    if !completed {
                        self.animateIdentity()
                    }
                    if completed {
                        self.animateIdentity()
                        self.resetImages()
                    }
                }
            }else if UIDevice.current.orientation.isLandscape {
                self.animateLandscape()
                
                share.completionWithItemsHandler = { (UIActivityType: UIActivity.ActivityType?, completed: Bool, returnItems: [Any]?, error: Error?) in
                    if !completed {
                        self.animateIdentity()
                    }
                    if completed {
                        self.animateIdentity()
                        self.resetImages()
                    }
                }
            }
        }
    }
    
    // Methods to check if all the photos are added
    var gridFilling = GridFilling() // instance class GridFilling
    func pictureViewIsFull() -> Bool { // Method to check all the layout are filling
        var fullFilling = false
        switch dispositionView.style {
        case .layoutOne:
            fullFilling = layoutOneFull()
        case .layoutTwo:
            fullFilling = layoutTwoFull()
        case .layoutThree:
            fullFilling = layoutThreeFull()
        }
        return fullFilling
    }
    func layoutOneFull() -> Bool { // Method to check if layout1 is filling
        if gridFilling.checkIfPhotoIsAdded(picture: leftTop),
            gridFilling.checkIfPhotoIsAdded(picture: leftBottom),
            gridFilling.checkIfPhotoIsAdded(picture: rightBottom) == true, true, true{ return true
        } else { messageToUser(); return false  }
    }
    func layoutTwoFull() -> Bool { // Method to check if layout2 is filling an
        if gridFilling.checkIfPhotoIsAdded(picture: leftTop),
            gridFilling.checkIfPhotoIsAdded(picture: rightTop),
            gridFilling.checkIfPhotoIsAdded(picture: leftBottom) == true, true, true{
            return true
        } else { messageToUser(); return false }
    }
    func layoutThreeFull() -> Bool { // Method to check if layout3 is filling
        if gridFilling.checkIfPhotoIsAdded(picture: leftTop),
            gridFilling.checkIfPhotoIsAdded(picture: rightTop),
            gridFilling.checkIfPhotoIsAdded(picture: leftBottom),
            gridFilling.checkIfPhotoIsAdded(picture: rightBottom) == true, true, true, true{
            return true
        } else  { messageToUser(); return false }
    }
    func messageToUser() { //Method to alert the user to complete the grid
        let alert = UIAlertController(title: "Incomplete photo editing", message: "You have to finish the grid", preferredStyle: .alert)
        let validate = UIAlertAction(title: "Finish the photo montage", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(validate)
        present(alert, animated: true, completion: nil)
    }
    
    // Methods to animate sharing (up, left and center)
    func animatePortrait () {
        let screenHeight = UIScreen.main.bounds.height
        UIView.animate(withDuration: 1, animations: {
            self.dispositionView.transform = CGAffineTransform(translationX: 0, y: -screenHeight)
        }, completion: nil)
    }
    func animateLandscape() {
        let screenLeft = UIScreen.main.bounds.width
        UIView.animate(withDuration: 1, animations: {
            self.dispositionView.transform = CGAffineTransform(translationX: -screenLeft, y: 0)
        }, completion: nil)
    }
    func animateIdentity() {
        UIView.animate(withDuration: 0.5, animations: {
            self.dispositionView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    // removes all images
    func resetImages() {
        leftTop.image = UIImage (named:"Combined Shape")
        leftTop.contentMode = .center
        rightTop.image = UIImage (named: "Combined Shape")
        rightTop.contentMode = .center
        leftBottom.image = UIImage (named: "Combined Shape")
        leftBottom.contentMode = .center
        rightBottom.image = UIImage (named: "Combined Shape")
        rightBottom.contentMode = .center
    }
    
    // Bonus : change background color
    // * Outlet to connect the button to change the color
    @IBOutlet weak var backGroundColor: UIButton!
    // ** Action for the method to change the color
    @IBAction func backGroundColor(_ sender: UIButton) {
        sender.tag += 1
        if sender.tag > 3 { sender.tag = 0}
        switch sender.tag {
        case 1:
            dispositionView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        case 2:
            dispositionView.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        case 3:
            dispositionView.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        default:
            dispositionView.backgroundColor = #colorLiteral(red: 0.1563128829, green: 0.4470875859, blue: 0.6286138892, alpha: 1)
        }
    }
}








