//
//  StickerFrameView.swift
//  Plugin
//
//  Created by Vitalii Kizlov on 02.03.2020.
//  Copyright © 2020 Max Lynch. All rights reserved.
//

import UIKit

class StickerFrameView: UIView {
    
    // MARK: - Internal Properties
    
    private let nibName = String(describing: StickerFrameView.self)
    private var initialCenter = CGPoint()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARk: - Outlets
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var stickerImageView: UIImageView!
    
    // MARK: - Setup View
    
    private func setupView() {
        let bundle = Bundle(for: StickerFrameView.self)
        bundle.loadNibNamed(nibName, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    // MARK: - Setup Gestures
    
    public func configureGestures() {
        configurePinchGesture()
        configurePanGesture()
        configureRotationGesture()
    }
    
    private func configurePinchGesture() {
        let pinchGesture = UIPinchGestureRecognizer()
        pinchGesture.addTarget(self, action: #selector(handlePinchGesture(_:)))
        self.addGestureRecognizer(pinchGesture)
    }
    
    private func configurePanGesture() {
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(handlePanGesture(_:)))
        self.addGestureRecognizer(panGesture)
    }
    
    private func configureRotationGesture() {
        let rotationGesture = UIRotationGestureRecognizer()
        rotationGesture.addTarget(self, action: #selector(handleRotationGesture(_:)))
        self.addGestureRecognizer(rotationGesture)
    }
    
    @objc private func handlePinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            gestureRecognizer.view?.transform = (gestureRecognizer.view?.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale))!
            gestureRecognizer.scale = 1.0
        }
    }
    
    @objc private func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        
        let piece = gestureRecognizer.view!
        
        let translation = gestureRecognizer.translation(in: piece.superview)
        
        if gestureRecognizer.state == .began {
            self.initialCenter = piece.center
        }
        
        if gestureRecognizer.state != .cancelled {
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            piece.center = newCenter
        } else {
            piece.center = initialCenter
        }
    }
    
    @objc private func handleRotationGesture(_ gestureRecognizer: UIRotationGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
           gestureRecognizer.view?.transform = gestureRecognizer.view!.transform.rotated(by: gestureRecognizer.rotation)
           gestureRecognizer.rotation = 0
        }
    }
    
}

