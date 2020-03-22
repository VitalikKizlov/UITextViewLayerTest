//
//  AlignView.swift
//  TextViewLayerTest
//
//  Created by Vitalii Kizlov on 04.03.2020.
//  Copyright © 2020 Vitalii Kizlov. All rights reserved.
//

import UIKit

class AllignView: UIView {
    
    // MARK: - Internal Properties
    
    private let nibName = String(describing: AllignView.self)
    var isAlignHidden = true
    
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
    @IBOutlet weak var alignRight: UIButton!
    @IBOutlet weak var alignLeft: UIButton!
    @IBOutlet weak var yellowView: UIView!
    
    // MARK: - Setup View
    
    private func setupView() {
        let bundle = Bundle(for: AllignView.self)
        bundle.loadNibNamed(nibName, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setHiddenState(isAlignHidden)
    }
    
    func setHiddenState(_ state: Bool) {
        alignLeft.isHidden = state
        alignRight.isHidden = state
        yellowView.isHidden = state
    }
    
    @IBAction func alignAction(_ sender: UIButton) {
        isAlignHidden = !isAlignHidden
        setHiddenState(isAlignHidden)
    }
    
    
}
