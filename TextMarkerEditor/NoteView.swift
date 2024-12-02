//
//  NoteView.swift
//  TextMarkerEditor
//
//  Created by HuyPT3 on 02/12/2024.
//

import UIKit

@IBDesignable
class NoteView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var dragView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        loadXib()
    }
    
    @IBAction func didTapMinimize(_ sender: Any) {
        
    }
    
    func loadXib() {
        Bundle.main.loadNibNamed(NoteView.className, owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        if let view = Bundle(for: NoteView.self).loadNibNamed(NoteView.className, owner: self, options: nil)?.first as? UIView {
//            view.frame = self.bounds
//            self.addSubview(view)
//        }
    }
}

extension NSObject {
    static var className: String {
        String(describing: self)
    }
}
