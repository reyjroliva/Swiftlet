//
//  SettingsViewController.swift
//  Swiftlet
//
//  Created by Rey Oliva on 2/25/19.
//  Copyright © 2019 Rey Oliva. All rights reserved.
//
import UIKit

var minutesPerMile = 0
var secondsPerMile = 0

class SettingsViewController: UIViewController {

    weak var delegate : SettingsViewContollerDelegate?
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var setDesiredPaceLbl: UILabel!
    @IBOutlet weak var minPerMiLbl: UILabel!
    @IBOutlet weak var secPerMiLbl: UILabel!
    @IBOutlet weak var minPerMi: UITextField!
    @IBOutlet weak var secPerMi: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Close Button
        closeBtn.setTitle("Close", for: .normal)
        
        //Set Desired Pace Label
        setDesiredPaceLbl.text = "Set Desired Pace"
        setDesiredPaceLbl.frame = CGRect(x: self.view.frame.width * 0.1, y: self.view.frame.height * 0.2, width: self.view.frame.width * 0.8, height: self.view.frame.height * 0.1)
        
        //set Min Per Mi Lbl
        minPerMiLbl.text = "Minutes Per\nMile"
        minPerMiLbl.frame = CGRect(x: self.view.frame.width * 0.05, y: setDesiredPaceLbl.frame.maxY + 10, width: self.view.frame.width * 0.4, height: self.view.frame.height * 0.1)
        
        //set Min Per Mi (textfield)
        minPerMi.frame = CGRect(x: self.view.frame.width  * 0.55, y: minPerMiLbl.frame.minY, width: minPerMiLbl.frame.width, height: minPerMiLbl.frame.height)
        minPerMi.attributedPlaceholder = NSAttributedString(string: "\(minutesPerMile)", attributes: [NSAttributedString.Key.foregroundColor: UIColor .white])
        minPerMi.layer.masksToBounds = true
        minPerMi.layer.cornerRadius = 20
        minPerMi.backgroundColor = swiftletBlue
        
        //set Sec Per Mi Lbl
        secPerMiLbl.text = "Seconds Per\nMile"
        secPerMiLbl.frame = CGRect(x: minPerMiLbl.frame.minX, y: minPerMiLbl.frame.maxY + 32, width: minPerMiLbl.frame.width, height: minPerMiLbl.frame.height)
        
        //set Sec Per Mi (textfield)
        secPerMi.frame = CGRect(x: minPerMi.frame.minX, y: secPerMiLbl.frame.minY, width: minPerMi.frame.width, height: minPerMi.frame.height)
        secPerMi.attributedPlaceholder = NSAttributedString(string: "\(secondsPerMile)", attributes: [NSAttributedString.Key.foregroundColor: UIColor .white])
        secPerMi.layer.masksToBounds = true
        secPerMi.layer.cornerRadius = 20
        secPerMi.backgroundColor = swiftletBlue
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func updateMinPerMile(_ sender: Any) {
        minutesPerMile = Int(minPerMi.text!) ?? 0
    }
    
    @IBAction func updateSecPerMi(_ sender: Any) {
        secondsPerMile = Int(secPerMi.text!) ?? 0
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onPressCloseBtn(_ sender: Any) {
        self.dismiss(animated: true, completion:{self.delegate?.updateDesPace()})
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
}
