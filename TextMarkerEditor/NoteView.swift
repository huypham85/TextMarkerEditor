//
//  NoteView.swift
//  TextMarkerEditor
//
//  Created by HuyPT3 on 02/12/2024.
//

import UIKit

class NoteView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var dragView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    var didOpenTextBox: (() -> Void)?
    
    private var initialSize: CGSize = .zero
    private var initialTouchPoint: CGPoint = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
        addGestures()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        loadXib()
    }
    
    @IBAction func didTapMinimize(_ sender: Any) {
        
    }
    
    func loadXib() {
        let viewFromXib = Bundle.main.loadNibNamed("NoteView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    
    private func addGestures() {
        // Pan gesture for moving the view
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.topView.addGestureRecognizer(panGesture)
        
        // Tap gesture for text input
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.contentView.addGestureRecognizer(tapGesture)
        
        // Pan gesture for resizing (on the resize handle only)
        let resizeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleResize(_:)))
        dragView.addGestureRecognizer(resizeGesture)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        self.contentView.center = CGPoint(x: contentView.center.x + translation.x, y: contentView.center.y + translation.y)

//        if let view = gesture.view {
//            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
//        }
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
        didOpenTextBox?()
//        textField.isHidden = false
//        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.isHidden = true
        return true
    }
}

extension NSObject {
    static var className: String {
        String(describing: self)
    }
}
