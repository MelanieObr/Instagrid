//
//  DispositionView.swift
//  Instagrid
//
//  Created by Mélanie Obringer on 25/04/2019.
//  Copyright © 2019 Mélanie Obringer. All rights reserved.
//

import UIKit

class DispositionView: UIView {
    // Connect for each outlet
    @IBOutlet var leftTop : UIImageView!
    @IBOutlet var rightTop : UIImageView!
    @IBOutlet var leftBottom : UIImageView!
    @IBOutlet var rightBottom : UIImageView!
    
    // enum to manage the view for each layout
    enum Style {
        case layoutOne, layoutTwo, layoutThree
    }
    
    var style: Style = .layoutThree {
        didSet {
            setStyle(_style: style)
        } 
    }
    
    // Method to arrange the style of each layout
    private func setStyle(_style: Style) {
        switch style {
        case .layoutOne:
            leftTop.isHidden = false
            rightTop.isHidden = true
            leftBottom.isHidden = false
            rightBottom.isHidden = false
            
        case .layoutTwo:
            leftTop.isHidden = false
            rightTop.isHidden = false
            leftBottom.isHidden = false
            rightBottom.isHidden = true
            
        case .layoutThree:
            leftTop.isHidden = false
            rightTop.isHidden = false
            leftBottom.isHidden = false
            rightBottom.isHidden = false
        }
    }
    // Configuration layouts when it's selected
    // * Outlets for the layouts
    @IBOutlet weak var layout1: UIButton!
    @IBOutlet weak var layout2: UIButton!
    @IBOutlet weak var layout3: UIButton!
    // ** Outlets for the image selected
    @IBOutlet weak var selected1: UIImageView!
    @IBOutlet weak var selected2: UIImageView!
    @IBOutlet weak var selected3: UIImageView!
    // *** Method to arrange the first layout when it's selected
    @IBAction func choiceLayout1(_ sender: UIButton) {
        layout1.isSelected = true
        selected1.isHidden = false
        selected2.isHidden = true
        selected3.isHidden = true
        style = .layoutOne
    }
    // **** Method to arrange the second layout when it's selected
    @IBAction func choiceLayout2(_ sender: UIButton) {
        layout2.isSelected = true
        selected1.isHidden = true
        selected2.isHidden = false
        selected3.isHidden = true
        style = .layoutTwo
    }
    // ***** Method to arrange the third layout when it's selected
    @IBAction func choiceLayout3(_ sender: UIButton) {
        layout3.isSelected = true
        selected1.isHidden = true
        selected2.isHidden = true
        selected3.isHidden = false
        style = .layoutThree
    }
    
}


