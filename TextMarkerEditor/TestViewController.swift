//
//  TestViewController.swift
//  TextMarkerEditor
//
//  Created by HuyPT3 on 02/12/2024.
//

import UIKit

class TestViewController: UIViewController {

//    @IBOutlet weak var noteView: NoteView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let noteView = NoteView(
            memoData: MemoData(
                frame: CGRect(x: 20, y: 30, width: 300, height: 600),
                isMinimized: false,
                text: "hello world",
                color: .init(UIColor(red: 34, green: 201, blue: 144, alpha: 1))
            )
        )
        noteView.isUserInteractionEnabled = true
        self.view.addSubview(noteView)
//        noteView.translatesAutoresizingMaskIntoConstraints = true
        noteView.contentLabel.text = "Huy"
        noteView.didOpenTextBox = {
            let vc = TextInputViewController()
            vc.didSaveEditText = { text in
                print("Saved text: \(text)")
                noteView.contentLabel.text = text
            }
            self.present(vc, animated: true)
        }
    }

}
