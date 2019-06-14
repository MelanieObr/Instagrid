//
//  GridFilling.swift
//  Instagrid
//
//  Created by Mélanie Obringer on 16/05/2019.
//  Copyright © 2019 Mélanie Obringer. All rights reserved.
//

import UIKit

// Class to check if a picture is added or not
class GridFilling : DispositionView {
    func checkIfPhotoIsAdded(picture: UIImageView) -> Bool{
        var photoOnPicture = false
        if picture.image != #imageLiteral(resourceName: "Combined Shape") {
            photoOnPicture = true
        } else {
            photoOnPicture = false
        }
        return photoOnPicture
    }
}



