//
//  ViewController.swift
//  Eyeballing
//
//  Created by Afir Thes on 10.10.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var drawView: DrawView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func goHandle(_ sender: Any) {
        drawView.randomiseExampleLine()
    }
    
    @IBAction func readyHandle(_ sender: Any) {
        let answer = "answer: \(drawView.answerLineWidth)\n"
        let example = "example: \(drawView.exampleLineWidth)\n"
        let diff = "diff: \(drawView.answerLineWidth - drawView.exampleLineWidth)\n"
        drawView.showText(text: diff)
    }
    
    @IBAction func decrementSize(_ sender: Any) {
        drawView.hideText()
        drawView.decrement()
    }
    
    @IBAction func incrementSize(_ sender: Any) {
        drawView.hideText()
        drawView.increment()
    }
    

}

