//
//  ViewController.swift
//  TextViewLayerTest
//
//  Created by Vitalii Kizlov on 29.02.2020.
//  Copyright © 2020 Vitalii Kizlov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, AddTextViewControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func addd(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddTextViewController") as! AddTextViewController
        vc.addTextViewControllerDelegate = self
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    func sendImage(_ image: UIImage, frame: CGRect) {
        let sticker = StickerFrameView(frame: CGRect(x: 20, y: 20, width: frame.width, height: frame.height))
        sticker.stickerImageView.image = image
        sticker.configureGestures()
        self.view.addSubview(sticker)
        self.view.bringSubviewToFront(sticker)
    }
    
}

