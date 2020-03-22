//
//  ColorPaletteView.swift
//  Plugin
//
//  Created by Vitalii Kizlov on 04.03.2020.
//  Copyright © 2020 Max Lynch. All rights reserved.
//

import UIKit

class ColorPaletteView: UIView {
    
    // MARK: - Internal Properties
    
    private let nibName = String(describing: ColorPaletteView.self)
    private var isColorPaletteViewHidden = true
    
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
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Setup View
    
    private func setupView() {
        let bundle = Bundle(for: ColorPaletteView.self)
        bundle.loadNibNamed(nibName, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        configureContent()
    }
    
    // MARK: - Actions
    
    @IBAction func colorButtonTapped(_ sender: UIButton) {
        isColorPaletteViewHidden = !isColorPaletteViewHidden
        configureHiddenStateForColorPaletteView(isColorPaletteViewHidden)
    }
    
    // MARK: - Private
    
    private func configureContent() {
        configureHiddenStateForColorPaletteView(isColorPaletteViewHidden)
        configureCollectionView()
    }
    
    private func configureHiddenStateForColorPaletteView(_ isHidden: Bool) {
       // colorPaletteView.isHidden = isHidden
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ColorCollectionViewCell.nib, forCellWithReuseIdentifier: ColorCollectionViewCell.reuseIdentifier)
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension ColorPaletteView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.reuseIdentifier, for: indexPath) as? ColorCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
