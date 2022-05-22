//
//  GamePlayerViewController.swift
//  buzzed
//
//  Created by Danielle Alota on 11/5/22.
//

import UIKit

class GamePlayerViewController: UIViewController {

    @IBOutlet weak var buttonImage: UIImageView!
    @IBAction func buttonDown(_ sender: Any) {
        buttonImage.image = UIImage(named: "buttonBuzzed.png")
    }
    //    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
