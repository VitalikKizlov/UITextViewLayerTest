//
//  AddTextViewController.swift
//  TextViewLayerTest
//
//  Created by Vitalii Kizlov on 29.02.2020.
//  Copyright © 2020 Vitalii Kizlov. All rights reserved.
//

import UIKit

protocol AddTextViewControllerDelegate: AnyObject {
    func sendImage(_ image: UIImage, frame: CGRect)
}

class AddTextViewController: UIViewController {
    
    
    @IBOutlet weak var mytextView: InputTextView!
    @IBOutlet weak var textStyleView: CustomizeTextStyleView!
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var alignViewBottomConstraint: NSLayoutConstraint!
    
    weak var addTextViewControllerDelegate: AddTextViewControllerDelegate?
    
    
    private let MAX_FONT_SIZE: CGFloat = 24.0
    private let MIN_FONT_SIZE: CGFloat = 16.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        mytextView.becomeFirstResponder()
        //mytextView.delegate = self
        mytextView.textContainer.lineBreakMode = .byTruncatingTail
        mytextView.highlightColor = .clear
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.25) {
                self.bottomViewBottomConstraint.constant = (keyboardSize.height - self.view.safeAreaInsets.bottom) + 4
                self.alignViewBottomConstraint.constant = keyboardSize.height
                self.textStyleView.layoutIfNeeded()
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.25) {
            self.bottomViewBottomConstraint.constant = 16
            self.textStyleView.layoutIfNeeded()
        }
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        //let image = mytextView.snapshot()!
        //addTextViewControllerDelegate?.sendImage(image)
        //self.dismiss(animated: true, completion: nil)
        
        let imageSize = UIScreen.main.bounds.size
        UIGraphicsBeginImageContextWithOptions(imageSize, _: false, _: 0)

        guard let context = UIGraphicsGetCurrentContext() else {
            print("NO CONTEXT AVAILABLE !!!")
            return
        }
        
        mytextView.tintColor = .clear
        self.renderView(mytextView, in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        
        
//        textLabel.text = mytextView.text
//        textLabel.textColor = mytextView.textColor
//        mytextView.isHidden = true
        /*
        UIGraphicsBeginImageContextWithOptions(textLabel.bounds.size, false, 0.0)
        textLabel.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        */
        
//        let renderer = UIGraphicsImageRenderer(size: textLabel.frame.size)
//        let image = renderer.image { (context) in
//            textLabel.layer.draw(in: context.cgContext)
//        }
        
        /*
        UIGraphicsBeginImageContextWithOptions(mytextView.bounds.size, false, UIScreen.main.scale)
        mytextView.drawHierarchy(in: mytextView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        */
        
        //let image = mytextView.toImage()!
        
        addTextViewControllerDelegate?.sendImage(image, frame: textLabel.frame)
        self.dismiss(animated: true, completion: nil)
    }
    
    func renderView(_ view: UIView, in context: CGContext) {
        context.saveGState()
        context.translateBy(x: view.center.x, y: view.center.y)
        context.concatenate(view.transform)
        context.translateBy(x: -(view.bounds.size.width) * (view.layer.anchorPoint.x), y: -(view.bounds.size.height) * (view.layer.anchorPoint.y))
        //view.layer.render(in: context)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        context.restoreGState()
    }
    
    @IBAction func changeColor(_ sender: UIButton) {
        mytextView.highlightColor = .purple
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        //let fixedWidth = textView.frame.size.width
        //let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        //mytextView.font = UIFont.systemFont(ofSize: max(MAX_FONT_SIZE - CGFloat(mytextView.text.count), MIN_FONT_SIZE))
        //updateTextFont(textView: textView)
        //mytextView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        //textView.fitText()
    }
    
    func updateTextFont(textView: UITextView) {
        /*
        if (textView.text.isEmpty || textView.bounds.size.equalTo(CGSize.zero)) {
            return;
        }

        let textViewSize = textView.frame.size;
        let fixedWidth = textViewSize.width;
        let expectSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))

        var expectFont = textView.font;
        if (expectSize.height > textViewSize.height) {
            while (textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height > textViewSize.height) {
                expectFont = textView.font!.withSize(textView.font!.pointSize - 1)
                textView.font = expectFont
            }
        }
        else {
            while (textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height < textViewSize.height) {
                expectFont = textView.font;
                textView.font = textView.font!.withSize(textView.font!.pointSize + 1)
            }
            textView.font = expectFont;
        }
        */
    }
    

}

extension UITextView {
    @objc public func fitText() {
        fitText(into: frame.size)
    }

    @objc public func fitText(into originalSize: CGSize) {
        let originalWidth = originalSize.width
        let expectedSize = sizeThatFits(CGSize(width: originalWidth, height: CGFloat(MAXFLOAT)))

        if expectedSize.height > originalSize.height {
            while let font = self.font, sizeThatFits(CGSize(width: originalWidth, height: CGFloat(MAXFLOAT))).height > originalSize.height {
                self.font = font.withSize(font.pointSize - 1)
            }
        } else {
            var previousFont = self.font
            while let font = self.font, sizeThatFits(CGSize(width: originalWidth, height: CGFloat(MAXFLOAT))).height < originalSize.height {
                previousFont = font
                self.font = font.withSize(font.pointSize + 1)
            }
            self.font = previousFont
            let s: CGFloat = 22
            if self.font!.pointSize > s {
                self.font = font!.withSize(s)
            } else {
                self.font = previousFont
            }
        }
    }
}

extension UIView {
    func snapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}

extension UITextView {
/**
 Convert TextView to UIImage
 */
 func toImage() -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
    defer { UIGraphicsEndImageContext() }
    if let context = UIGraphicsGetCurrentContext() {
        self.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
    return nil
  }
}
