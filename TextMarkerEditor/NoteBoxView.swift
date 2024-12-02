//
//  NoteBoxView.swift
//  TextMarkerEditor
//
//  Created by HuyPT3 on 02/12/2024.
//

import Foundation
import UIKit

class NoteBoxView: UIView, UIGestureRecognizerDelegate, UITextFieldDelegate {
    private var textField: UITextField!
    private var resizeHandle: UIView!
    private var initialSize: CGSize = .zero
    private var initialTouchPoint: CGPoint = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addGestures()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        addGestures()
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        
        // TextField setup
        textField = UITextField()
        textField.isHidden = true
        textField.delegate = self
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        self.addSubview(textField)
        
        // Resize handle setup
        resizeHandle = UIView()
        resizeHandle.backgroundColor = .darkGray
        resizeHandle.layer.cornerRadius = 4
        resizeHandle.clipsToBounds = true
        self.addSubview(resizeHandle)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textField.frame = CGRect(x: 10, y: (self.bounds.height - 30) / 2, width: self.bounds.width - 20, height: 30)
        resizeHandle.frame = CGRect(x: self.bounds.width - 20, y: self.bounds.height - 20, width: 20, height: 20)
    }
    
    private func addGestures() {
        // Pan gesture for moving the view
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.addGestureRecognizer(panGesture)
        
        // Tap gesture for text input
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tapGesture)
        
        // Pan gesture for resizing (on the resize handle only)
        let resizeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleResize(_:)))
        resizeHandle.addGestureRecognizer(resizeGesture)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        if let view = gesture.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        }
        gesture.setTranslation(.zero, in: self.superview)
    }
    
    @objc private func handleResize(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self)
        
        if gesture.state == .began {
            initialSize = self.frame.size
            initialTouchPoint = location
        } else if gesture.state == .changed {
            let deltaX = location.x - initialTouchPoint.x
            let deltaY = location.y - initialTouchPoint.y
            
            let newWidth = max(50, initialSize.width + deltaX)
            let newHeight = max(50, initialSize.height + deltaY)
            
            self.frame.size = CGSize(width: newWidth, height: newHeight)
        }
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        textField.isHidden = false
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.isHidden = true
        return true
    }
}


