//
//  SavedDetailsViewController.swift
//  ArtBook
//
//  Created by Veysal on 12.09.22.
//

import UIKit

class SavedDetailsViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    var imageV = UIImage()
    var name = ""
    var year = 0
    var artist = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.image = imageV
        nameLabel.text = name
        yearLabel.text = String(year)
        artistLabel.text = artist

    }
    
 

}
