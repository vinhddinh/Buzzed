//
//  GameHostViewController.swift
//  buzzed
//
//  Created by Danielle Alota on 11/5/22.
//

import UIKit
import MultipeerConnectivity

class GameHostViewController: UIViewController{
    
    @IBOutlet var confirmEndView: UIView!
    @IBOutlet var blurView: UIVisualEffectView!
    
    //Spawns in confirmEndView
    @IBAction func endGameButtonPressed(_ sender: Any) {
        confirmEndView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.5) //width is 90% screen and height is 50% height
        blurView.bounds = self.view.bounds;
        animateIn(view: blurView);
        animateIn(view: confirmEndView);
    }
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
//        mpcHandler.advertiser?.stop()
    }
    
    
    //Animates in blurred background
    func animateIn(view: UIView){
        let background = self.view!
        background.addSubview(view)
        view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        view.alpha = 0
        view.center = background.center
        UIView.animate(withDuration: 0.3, animations: {
            view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            view.alpha = 1
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

extension GameHostViewController: MPCHandlerDelegate {
    func changed(state: MCSessionState, of peer: MCPeerID) {
    }
    
    func received(data: Data, from peer: MCPeerID) {
    }
    
    
}
