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
    @IBOutlet weak var contentTextView: UIView!
    @IBOutlet weak var noteImageView: UIImageView!
    var didOpenTextBox: (() -> Void)?
    
    private var initialSize: CGSize = .zero
    private var initialTouchPoint: CGPoint = .zero
    private var isMinimized = false
    private var originalFrame: CGRect = .zero
    private var minimizedFrame: CGRect = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        originalFrame = frame
        loadXib()
        addGestures()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @IBAction func didTapMinimize(_ sender: Any) {
        if isMinimized {
            return
        }
        topView.isHidden = true
        contentLabel.isHidden = true
        dragView.isHidden = true
        noteImageView.isHidden = false
        minimizedFrame = CGRect(x: originalFrame.origin.x, y: originalFrame.origin.y, width: 100, height: 200)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = self.minimizedFrame
            self.layer.cornerRadius = self.frame.height / 2
        }) { _ in
            self.isMinimized = true
        }
    }
    
    func loadXib() {
        let viewFromXib = Bundle.main.loadNibNamed("NoteView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    
    private func addGestures() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.contentTextView.addGestureRecognizer(tapGesture)
        
        let resizeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleResize(_:)))
        dragView.addGestureRecognizer(resizeGesture)
    }
    
    @objc private func handleResize(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self)
        
        if gesture.state == .began {
            initialSize = self.frame.size
            initialTouchPoint = location
        } else if gesture.state == .changed {
            let deltaX = location.x - initialTouchPoint.x
            let deltaY = location.y - initialTouchPoint.y
            let newWidth = max(200, initialSize.width + deltaX)
            let newHeight = max(300, initialSize.height + deltaY)
            
            self.frame.size = CGSize(width: newWidth, height: newHeight)
            self.originalFrame.size = CGSize(width: newWidth, height: newHeight)
        }
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        if isMinimized {
            topView.isHidden = false
            contentLabel.isHidden = false
            dragView.isHidden = false
            noteImageView.isHidden = true
            UIView.animate(withDuration: 0.5, animations: {
                self.frame = self.originalFrame
            }) { _ in
                self.isMinimized = false
            }
        } else {
            didOpenTextBox?()
        }
        
    }
}
