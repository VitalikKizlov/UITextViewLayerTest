//
//  InputTextView.swift
//  TextViewLayerTest
//
//  Created by Vitalii Kizlov on 03.03.2020.
//  Copyright © 2020 Vitalii Kizlov. All rights reserved.
//

import UIKit

class InputTextView: UITextView, UITextViewDelegate {
    
        let cornerRadius: CGFloat = 8
        var highlightColor: UIColor = UIColor.white

        override init(frame: CGRect, textContainer: NSTextContainer?) {
            super.init(frame: frame, textContainer: textContainer)
            initialize()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            initialize()
        }

        private func initialize() {
            self.delegate = self
            self.isScrollEnabled = false
            self.textContainerInset = UIEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius)
        }

        override var intrinsicContentSize: CGSize {
            self.set()
            return super.intrinsicContentSize
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            self.set()
        }

        func textViewDidChange(_ textView: UITextView) {
            set()
        }

        func set() {

            // 1. 各行の CGRect(rects) を取得
            var rects = self.text.lineRanges.map({ range -> CGRect in
                var rect = self.layoutManager.boundingRect(forGlyphRange: range, in: self.textContainer)
                rect.origin.x += self.textContainerInset.left
                rect.origin.y += self.textContainerInset.top
                if !self.text.substring(with: range).isEmpty {
                    rect.origin.x -= cornerRadius
                    rect.size.width += cornerRadius * 2
                }
                rect.origin.y -= 1
                rect.size.height += 1
                return rect
            })

            // 2. 左端を揃える
            repeat {
                for i in rects.indices.dropLast() {
                    let diffMinX = rects[i].minX - rects[i+1].minX
                    guard abs(diffMinX) < cornerRadius * 2 && diffMinX != 0 && rects[i].width != 0 && rects[i+1].width != 0 else { continue }

                    switch diffMinX {
                    case ...0:
                        rects[i+1].size.width += abs(diffMinX)
                        rects[i+1].origin.x = rects[i].origin.x
                    case 0...:
                        rects[i].size.width += abs(diffMinX)
                        rects[i].origin.x = rects[i+1].origin.x
                    default:
                        break
                    }
                }
            } while rects.eachPair().filter({ $0.0.width != 0 && $0.1.width != 0 }).map({ abs($0.0.minX - $0.1.minX) }).contains(where: { $0 < self.cornerRadius * 2 && $0 != 0 })

            // 2. 右端を揃える
            repeat {
                for i in rects.indices.dropLast() {
                    let diffMaxX = rects[i].maxX - rects[i+1].maxX
                    guard abs(diffMaxX) < cornerRadius * 2 && diffMaxX != 0 && rects[i].width != 0 && rects[i+1].width != 0 else { continue }

                    switch diffMaxX {
                    case ...0:
                        rects[i].size.width += abs(diffMaxX)
                    case 0...:
                        rects[i+1].size.width += abs(diffMaxX)
                    default:
                        break
                    }
                }
            } while rects.eachPair().filter({ $0.0.width != 0 && $0.1.width != 0 }).map({ abs($0.0.maxX - $0.1.maxX) }).contains(where: { $0 < self.cornerRadius * 2 && $0 != 0 })

            // 3. rects に対応する BumpyCorner の配列(corners)を用意
            var corners = [BumpyCorner](repeating: BumpyCorner(), count: rects.count)

            // 4. 最初の行の上部2つの角, 最後の行の下部2つの角, は必ず丸い
            if !corners.isEmpty {
                corners[0].topLeft = .contraction
                corners[0].topRight = .contraction
                corners[corners.count - 1].bottomLeft = .contraction
                corners[corners.count - 1].bottomRight = .contraction
            }

            // 4. 各行の間の角4つ
            for i in rects.indices.dropLast() {
                // 左端
                let diffMinX = rects[i].minX - rects[i+1].minX
                if diffMinX < 0 {
                    // 上の行が左側に出っ張る
                    corners[i].bottomLeft = .contraction
                    corners[i+1].topLeft = .expansion
                } else if diffMinX > 0 {
                    // 下の行が左側に出っ張る
                    corners[i].bottomLeft = .expansion
                    corners[i+1].topLeft = .contraction
                }

                // 右端
                let diffMaxX = rects[i].maxX - rects[i+1].maxX
                if diffMaxX < 0 {
                    // 下の行が右側に出っ張る
                    corners[i].bottomRight = .expansion
                    corners[i+1].topRight = .contraction
                } else if diffMaxX > 0 {
                    // 下の行が左側に出っ張る
                    corners[i].bottomRight = .contraction
                    corners[i+1].topRight = .expansion
                }
            }

            // 4. 文字のないところは真っ直ぐ
            for i in rects.indices where rects[i].width == 0 {
                corners[i].topLeft = .none
                corners[i].topRight = .none
                corners[i].bottomLeft = .none
                corners[i].bottomRight = .none
            }

            // 5. rects と corners を元に各行の UIBezierPath(paths) を用意
            let paths = rects.indices.map({ UIBezierPath(rect: rects[$0], bumpyCorner: corners[$0], cornerRadius: cornerRadius) })

            // 6. paths を元に CAShapeLayer を用意
            self.layer.sublayers?.filter({ $0.name == "highlight" }).forEach({ $0.removeFromSuperlayer() })
            for path in paths {
                let shapeLayer = CAShapeLayer(fill: highlightColor, zPosition: -1, path: path, frame: self.bounds, name: "highlight")
                self.layer.addSublayer(shapeLayer)
            }
        }
    
}

extension String {
    var lineRanges: [NSRange] {
        let lines = self.components(separatedBy: .newlines)
        let ranges = lines.reduce([]) { result, line -> [NSRange] in
            let location = result.map({ $0.length }).sum() + result.count
            return result + [NSRange(location: location, length: line.count)]
        }
        return ranges
    }
    
        func substring(with range: NSRange) -> String {
            return (self as NSString).substring(with: range)
        }
}

extension Array where Element == Int {
    func sum() -> Int {
        return self.reduce(0, { $0 + $1 })
    }
}

extension Array {
    func eachPair() -> [(Element, Element)] {
        return zip(self, self.dropFirst()).map({ ($0.0, $0.1) })
    }
}

struct BumpyCorner {
    var topLeft: Kind
    var topRight: Kind
    var bottomLeft: Kind
    var bottomRight: Kind

    init(topLeft: Kind = .none, topRight: Kind = .none, bottomLeft: Kind = .none, bottomRight: Kind = .none) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }

    enum Kind {
        case expansion   // 膨張
        case none        // なし
        case contraction // 収縮
    }
}

extension UIBezierPath {

    convenience init(rect: CGRect, bumpyCorner corner: BumpyCorner, cornerRadius radius: CGFloat) {
        self.init()

        self.move(to: CGPoint(x: rect.origin.x + radius, y: rect.minY))

        switch corner.topRight {
        case .expansion:
            self.addLine(to: CGPoint(x: rect.maxX + radius, y: rect.minY))
            self.addArc(withCenter: CGPoint(x: rect.maxX + radius, y: rect.minY + radius), radius: radius, startAngle: CGFloat.pi * 1.5, endAngle: CGFloat.pi, clockwise: false)
        case .none:
            self.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        case .contraction:
            self.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
            self.addArc(withCenter: CGPoint(x: rect.maxX - radius, y: rect.minY + radius), radius: radius, startAngle: CGFloat.pi * 1.5, endAngle: 0, clockwise: true)
        }

        switch corner.bottomRight {
        case .expansion:
            self.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
            self.addArc(withCenter: CGPoint(x: rect.maxX + radius, y: rect.maxY - radius), radius: radius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 0.5, clockwise: false)
        case .none:
            self.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        case .contraction:
            self.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
            self.addArc(withCenter: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius), radius: radius, startAngle: 0, endAngle: CGFloat.pi * 0.5, clockwise: true)
        }

        switch corner.bottomLeft {
        case .expansion:
            self.addLine(to: CGPoint(x: rect.minX - radius, y: rect.maxY))
            self.addArc(withCenter: CGPoint(x: rect.minX - radius, y: rect.maxY - radius), radius: radius, startAngle: CGFloat.pi * 0.5, endAngle: 0, clockwise: false)
        case .none:
            self.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        case .contraction:
            self.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
            self.addArc(withCenter: CGPoint(x: rect.minX + radius, y: rect.maxY - radius), radius: radius, startAngle: CGFloat.pi * 0.5, endAngle: CGFloat.pi, clockwise: true)
        }

        switch corner.topLeft {
        case .expansion:
            self.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
            self.addArc(withCenter: CGPoint(x: rect.minX - radius, y: rect.minY + radius), radius: radius, startAngle: 0, endAngle: CGFloat.pi * 1.5, clockwise: false)
        case .none:
            self.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        case .contraction:
            self.addLine(to: CGPoint(x: rect.minX, y: rect.maxY + radius))
            self.addArc(withCenter: CGPoint(x: rect.minX + radius, y: rect.minY + radius), radius: radius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 1.5, clockwise: true)
        }

        self.close()
    }
}

extension CAShapeLayer {

    convenience init(fill color: UIColor?, zPosition: CGFloat = 0, path: UIBezierPath, frame: CGRect, name: String? = nil) {
        self.init()
        self.fillColor = color?.cgColor
        self.zPosition = zPosition
        self.path = path.cgPath
        self.frame = frame
        self.name = name
    }
}
