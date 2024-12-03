//
//  TextInputViewController.swift
//  TextMarkerEditor
//
//  Created by Huy Pham on 2/12/24.
//

import UIKit

class TextInputViewController: UIViewController {
    var didSaveEditText: ((String) -> Void)?
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        // Set up navigation bar
        self.title = "Edit Note"
    }
    
    // Actions for buttons
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSave(_ sender: Any) {
        let enteredText = textView.text ?? ""
        print("Saved text: \(enteredText)")
        didSaveEditText?(enteredText)
        dismiss(animated: true, completion: nil)
    }
}
