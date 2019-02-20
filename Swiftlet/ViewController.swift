//
//  ViewController.swift
//  Swiftlet
//
//  Created by Rey Oliva on 2/14/19.
//  Copyright © 2019 Rey Oliva. All rights reserved.
//

import UIKit

let swiftletGreen = UIColor(red: 0.35, green: 0.8, blue: 0.1, alpha: 1.0);
let swiftletRed = UIColor(red: 0.8, green: 0.1, blue: 0.1, alpha: 1.0);


class ViewController: UIViewController {
    
    @IBOutlet weak var startPauseBtn: UIButton!
    @IBOutlet weak var endBtn: UIButton!
    @IBOutlet weak var currPaceLbl: UILabel!
    @IBOutlet weak var desPaceLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    
    
    var started = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set Labels
        currPaceLbl.text = "Current\nPace";
        
        //Set startPauseBtn
        startPauseBtn.setTitle("Start", for: .normal);
        startPauseBtn.setTitleColor(UIColor .white, for: .normal);
        startPauseBtn.backgroundColor = swiftletGreen;
        startPauseBtn.frame = CGRect(x: self.view.frame.width * 0.05, y: self.view.frame.height * 0.7, width: self.view.frame.width * 0.9, height: self.view.frame.height * 0.1);
        startPauseBtn.layer.cornerRadius = 10;
        
        //Set endBtn
        endBtn.setTitle("End", for: .normal);
        endBtn.setTitleColor(UIColor .white, for: .normal);
        endBtn.backgroundColor = swiftletRed;
        endBtn.frame = CGRect(x: startPauseBtn.frame.minX, y: startPauseBtn.frame.maxY + 10, width: startPauseBtn.frame.width, height: startPauseBtn.frame.height);
        endBtn.layer.cornerRadius = 10;
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func startPauseBtnPressed(_ sender: Any) {
        if(!started) {
            started = true;
            startPauseBtn.setTitle("Pause", for: .normal);
            startPauseBtn.backgroundColor = swiftletRed;
            startPauseBtn.frame = CGRect(x: self.view.frame.width * 0.05, y: self.view.frame.height * 0.7, width: self.view.frame.width * 0.9, height: self.view.frame.height * 0.2);
            endBtn.isHidden = true;
        }
        else {
            started = false;
            startPauseBtn.setTitle("Start", for: .normal);
            startPauseBtn.backgroundColor = swiftletGreen;
            startPauseBtn.frame = CGRect(x: self.view.frame.width * 0.05, y: self.view.frame.height * 0.7, width: self.view.frame.width * 0.9, height: self.view.frame.height * 0.1);
            endBtn.isHidden = false;
        }
    }
    
    @IBAction func endBtnPressed(_ sender: Any) {
    }
}

