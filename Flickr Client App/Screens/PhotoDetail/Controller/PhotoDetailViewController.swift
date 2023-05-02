//
//  PhotoDetailViewController.swift
//  Flickr Client App
//
//  Created by furkan sakız on 26.04.2023.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    var photo: Photo?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ownerNameLabel.text = photo?.ownername
        ownerImageView.layer.cornerRadius = 24.0
        
        NetworkManager.shared.fetchImage(with: photo?.buddyIconUrl) { data in
            self.ownerImageView.image = UIImage(data: data)
        }
        
        NetworkManager.shared.fetchImage(with: photo?.urlZ) { data in
            self.imageView.image = UIImage(data: data)
        }
        
        title = photo?.title
        
        descriptionLabel.text = photo?.description?.content
    }
}
