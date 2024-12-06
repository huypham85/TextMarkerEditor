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
    @IBOutlet weak var dragView: MemoCornerView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentTextView: UIView!
    var didOpenTextBox: (() -> Void)?
    
    private var initialSize: CGSize = .zero
    private var initialTouchPoint: CGPoint = .zero
    private var isMinimized = false
    private var originalFrame: CGRect = .zero
    private var minimizedFrame: CGRect = .zero
    
    private var minimizeMoveGesture: UIPanGestureRecognizer?
    static let initWidth: CGFloat = 200
    static let initHeight: CGFloat = 300
    static let minimizedWidth: CGFloat = 50
    static let minimizedHeight: CGFloat = 75
    
    var memoData: MemoData?
    
    init(memoData: MemoData) {
        self.memoData = memoData
        super.init(frame: memoData.frame ?? .zero)
        originalFrame = frame
        loadXib()
        setupView()
        addGestures()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @IBAction func didTapMinimize(_ sender: Any) {
        if isMinimized {
            return
        }
        originalFrame = self.frame
        topView.isHidden = true
        contentLabel.isHidden = true
        dragView.isHidden = true
        
        minimizedFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: NoteView.minimizedWidth, height: NoteView.minimizedHeight)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = self.minimizedFrame
            self.layer.cornerRadius = self.frame.height / 2
        }) { _ in
            self.isMinimized = true
            self.minimizeMoveGesture?.isEnabled = true
        }
    }
    
    private func setupView() {
        self.frame = memoData?.frame ?? CGRect(x: 0, y: 0, width: NoteView.initWidth, height: NoteView.initHeight)
        self.originalFrame = self.frame
        self.isMinimized = memoData?.isMinimized ?? false
        self.contentLabel.text = memoData?.text
        self.topView.backgroundColor = memoData?.color?.uiColor
        self.dragView.updateFillColor(memoData?.color?.uiColor ?? UIColor.red)
        self.contentTextView.backgroundColor = memoData?.color?.uiColor.withAlphaComponent(0.3)
        if isMinimized {
            topView.isHidden = true
            contentLabel.isHidden = true
            dragView.isHidden = true
            self.frame = CGRect(x: memoData?.frame?.origin.x ?? 0, y: memoData?.frame?.origin.y ?? 0, width: NoteView.minimizedWidth, height: NoteView.minimizedHeight)
            self.layer.cornerRadius = self.frame.height / 2
        }
    }
    
    func loadXib() {
        let viewFromXib = Bundle.init(for: NoteView.self).loadNibNamed("NoteView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
    }
    
    private func addGestures() {
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(doNothing)))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.contentTextView.addGestureRecognizer(tapGesture)
        
        let resizeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleResize(_:)))
        dragView.addGestureRecognizer(resizeGesture)
        
        let headerMoveGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMove(_:)))
        topView.addGestureRecognizer(headerMoveGesture)
        topView.isUserInteractionEnabled = true
        
        minimizeMoveGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMove(_:)))
        self.addGestureRecognizer(minimizeMoveGesture!)
        minimizeMoveGesture?.isEnabled = false
        
        
    }
    
    @objc private func doNothing() {
        
    }
    
    @objc private func handleMove(_ gesture: UIPanGestureRecognizer) {

        guard let parent = self.superview else { return }
        
        let translation = gesture.translation(in: parent)
        var newX = self.center.x + translation.x
        var newY = self.center.y + translation.y
        let currentFrame = self.frame
        if (newX - currentFrame.width / 2) < 0 {
            newX = currentFrame.width / 2
        } else if (newX + currentFrame.width / 2) > parent.frame.width {
            newX = parent.frame.width - currentFrame.width / 2
        }
         
        if (newY - currentFrame.height / 2) < 0 {
            newY = currentFrame.height / 2
        } else if (newY + currentFrame.height / 2) > parent.frame.height {
            newY = parent.frame.height - currentFrame.height / 2
        }
        
        self.center = CGPoint(x: newX, y: newY)
        gesture.setTranslation(CGPoint.zero, in: parent)
    }
    
    @objc private func handleResize(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self)
        
        if gesture.state == .began {
            initialSize = self.frame.size
            initialTouchPoint = location
        } else if gesture.state == .changed {
            let deltaX = location.x - initialTouchPoint.x
            let deltaY = location.y - initialTouchPoint.y
            let newWidth = max(NoteView.initWidth, initialSize.width + deltaX)
            let newHeight = max(NoteView.initHeight, initialSize.height + deltaY)
            
            self.frame.size = CGSize(width: newWidth, height: newHeight)
            self.originalFrame.size = CGSize(width: newWidth, height: newHeight)
        }
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        if isMinimized {
            topView.isHidden = false
            contentLabel.isHidden = false
            dragView.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.frame = CGRect.init(origin: self.frame.origin, size: self.originalFrame.size)
            }) { _ in
                self.isMinimized = false
                self.minimizeMoveGesture?.isEnabled = false
            }
        } else {
            didOpenTextBox?()
        }
        
    }
}


public struct PageMemoData: Codable {
    
    var pageIndex: Int?
//    var mode: PDFViewer.PageViewMode = .singlePage //single, left, right
    var memoItems: [MemoData] = []
    
    public init(pageIndex: Int, memoItems: [MemoData]) {
        self.pageIndex = pageIndex
//        self.mode = mode
        self.memoItems = memoItems
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.pageIndex = try container.decodeIfPresent(Int.self, forKey: .pageIndex)
//        self.mode = try container.decodeIfPresent(PDFViewer.PageViewMode.self, forKey: .mode) ?? .singlePage
        self.memoItems = try container.decodeIfPresent([MemoData].self, forKey: .memoItems) ?? []
    }
    
    public func decode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(pageIndex, forKey: .pageIndex)
//        try container.encode(mode, forKey: .mode)
        try container.encode(memoItems, forKey: .memoItems)
    }
    
}

public struct MemoData: Codable {
    
    var frame: CGRect?
    var isMinimized: Bool?
    var text: String?
    var color: Color?
    
    public init(frame: CGRect, isMinimized: Bool, text: String, color: Color) {
        self.frame = frame
        self.isMinimized = isMinimized
        self.text = text
        self.color = color
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.frame = try container.decodeIfPresent(CGRect.self, forKey: .frame)
        self.isMinimized = try container.decodeIfPresent(Bool.self, forKey: .isMinimized)
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
        self.color = try container.decodeIfPresent(Color.self, forKey: .color)
    }
    
    public func decode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(frame, forKey: .frame)
        try container.encode(isMinimized, forKey: .isMinimized)
        try container.encode(text, forKey: .text)
        try container.encode(color, forKey: .color)
    }
    
    
    
}

public struct Color : Codable {
    private var red: CGFloat = 0.0
    private var green: CGFloat = 0.0
    private var blue: CGFloat = 0.0
    private var alpha: CGFloat = 0.0
 
    public var uiColor: UIColor {
        UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }
 
    public init(_ uiColor: UIColor) {
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    }
}

