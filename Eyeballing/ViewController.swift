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


    @IBAction func drawRect(_ sender: Any) {
        drawView.drawShape(selectedShape: .rectangle)
    }
    
    @IBAction func drawFilledRect(_ sender: Any) {
        drawView.drawShape(selectedShape: .filledRectangle)
    }
    
    @IBAction func drawCircle(_ sender: Any) {
        drawView.drawShape(selectedShape: .circle)
    }
    
    @IBAction func drawFilledCircle(_ sender: Any) {
        drawView.drawShape(selectedShape: .filledCircle)
    }
    
}

