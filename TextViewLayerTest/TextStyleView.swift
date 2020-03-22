//
//  TextStyleView.swift
//  TextViewLayerTest
//
//  Created by Vitalii Kizlov on 04.03.2020.
//  Copyright © 2020 Vitalii Kizlov. All rights reserved.
//

import UIKit

class CustomizeTextStyleView: UIView {
    
    // MARK: - Internal Properties
    
    private let nibName = String(describing: CustomizeTextStyleView.self)
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Outlets
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var instaStyleButton: UIButton!
    
    @IBOutlet weak var leftAllignButton: UIButton!
    @IBOutlet weak var rightAllignButton: UIButton!
    
    var isAllignHidden = true
    
    // MARK: - Setup View
    
    private func setupView() {
        let bundle = Bundle(for: CustomizeTextStyleView.self)
        bundle.loadNibNamed(nibName, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        //instaStyleButton.layer.cornerRadius = 5
        //triggerAllignHiddenState(isAllignHidden)
    }
    
    public func triggerAllignHiddenState(_ state: Bool) {
        leftAllignButton.isHidden = state
        rightAllignButton.isHidden = state
    }
    
    @IBAction func allignButtonTapped(_ sender: UIButton) {
        isAllignHidden = !isAllignHidden
        triggerAllignHiddenState(isAllignHidden)
    }
    
    
}
