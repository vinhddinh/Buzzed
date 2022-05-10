//
//  LobbyHostViewController.swift
//  buzzed
//
//  Created by Danielle Alota on 11/5/22.
//

import UIKit

class LobbyHostViewController: UIViewController {

    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var timeLimitSlider: UISlider!
    @IBOutlet weak var timeLimitLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomNameLabel.text = UIDevice.current.name; //grabs the device's name

        // Do any additional setup after loading the view.
    }
    
    
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
