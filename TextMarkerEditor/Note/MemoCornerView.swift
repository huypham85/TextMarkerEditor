//
//  MemoCornerView.swift
//  TextMarkerEditor
//
//  Created by HuyPT3 on 06/12/2024.
//

import UIKit

@IBDesignable
class MemoCornerView: UIView {
    private var fillColor: UIColor = .systemYellow

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        let triangleLayer = CAShapeLayer()
        triangleLayer.path = createTrianglePath().cgPath
        triangleLayer.fillColor = fillColor.cgColor
        layer.addSublayer(triangleLayer)
    }
    
    func updateFillColor(_ color: UIColor) {
        fillColor = color
        setupView()
    }
    
    private func createTrianglePath() -> UIBezierPath {
        let path = UIBezierPath()
        let width = self.bounds.width
        let height = self.bounds.height
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()
        
        return path
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        setupView()
    }
}

