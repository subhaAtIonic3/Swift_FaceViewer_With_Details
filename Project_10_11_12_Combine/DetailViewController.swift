//
//  DetailViewController.swift
//  Project_10_11_12_Combine
//
//  Created by Subhrajyoti Chakraborty on 20/07/20.
//  Copyright © 2020 Subhrajyoti Chakraborty. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var faceImageView: UIImageView!
    var titleString: String?
    var imagePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = titleString
        
        navigationItem.largeTitleDisplayMode = .never
        
        if let safeImagePath = imagePath {
            faceImageView.image = UIImage(contentsOfFile: safeImagePath)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.hidesBarsOnTap = false
    }

}
