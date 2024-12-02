//
//  ViewController.swift
//  TextMarkerEditor
//
//  Created by HuyPT3 on 02/12/2024.
//

import UIKit

class ViewController: UIViewController {
    
    lazy private var sampleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello World!"
        label.textColor = UIColor.white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let customView = NoteBoxView(frame: CGRect(x: 100, y: 100, width: 200, height: 200))
//        let customView2 = NoteView(frame: CGRect(x: 300, y: 500, width: 200, height: 200))
        view.addSubview(customView)
//        view.addSubview(customView2)
        
    }
    
    func setUpConstraints() {
        let sampleLabelConstraints = [
            self.sampleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.sampleLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(sampleLabelConstraints)
    }
    
}
