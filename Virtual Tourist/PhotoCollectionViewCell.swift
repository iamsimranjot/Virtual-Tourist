//
//  PhotoCollectionViewCell.swift
//  Virtual Tourist
//
//  Created by SimranJot Singh on 16/04/17.
//  Copyright © 2017 SimranJot Singh. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    
    //MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    //MARK: Properties
    
    var image: Photos? = nil {
        didSet {
            
            //TODO: Set Image
        }
    }
    
    var isLoading: Bool {
        set {
            
            if newValue {
                
                imageView.image = nil
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
            }
            else {
                activityIndicator.stopAnimating()
                activityIndicator.isHidden = true
            }
        }
        get {
            
            return !activityIndicator.isHidden
        }
    }
}
