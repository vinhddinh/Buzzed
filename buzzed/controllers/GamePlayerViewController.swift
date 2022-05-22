//
//  GamePlayerViewController.swift
//  buzzed
//
//  Created by Danielle Alota on 11/5/22.
//

import UIKit
import MultipeerConnectivity

class GamePlayerViewController: UIViewController {
    var peerID = MCPeerID (displayName: UIDevice.current.name)
    var mcSession: MCSession!
    var browser: MCBrowserViewController!
    var advertiser: MCAdvertiserAssistant?
    var delegate: MPCHandlerDelegate?

    var buzzed: Bool = false
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var buttonImage: UIImageView!
    @IBAction func buttonDown(_ sender: Any) {
        if !buzzed {
            lockBuzzer()
            
            // Make call to the host that this peer buzzed in
            if mcSession.connectedPeers.count > 0 {
                do {
                    // Broadcast peer ID for host to receive
                    try mcSession.send(Data(peerID.displayName.utf8), toPeers: mcSession.connectedPeers, with: .reliable)
                } catch let error as NSError {
                    // Handle error
                    print(error.localizedDescription);
                }
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let serverMessage = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async { [unowned self] in
                if (serverMessage == "LOCKBUZZERS")
                {
                    lockBuzzer()
                }
                else if (serverMessage == "RESETBUZZZERS")
                {
                    resetBuzzer()
                }
            }
        }
    }

    
//    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
//        if let playerName = String(data: data, encoding: .utf8) {
//            DispatchQueue.main.async { [unowned self] in
//                if (playerName != "LOCKBUZZERS")
//                {
//                    // TODO: Identify player with name playerName as having buzzed in first
//
//                    // Tell all players to lock their buzzers
//                    if mcSession.connectedPeers.count > 0 {
//                        do {
//                            // Broadcast message for players to lock buzzers
//                            try mcSession.send(Data("LOCKBUZZERS".utf8), toPeers: mcSession.connectedPeers, with: .reliable)
//                        } catch let error as NSError {
//                            // Handle error
//                            print(error.localizedDescription);
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    func lockBuzzer() {
        buttonImage.image = UIImage(named: "buttonBuzzed.png")
        buzzed = true
    }
    
    func resetBuzzer() {
        buttonImage.image = UIImage(named: "buttonBuzz.png")
        buzzed = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        button.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
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
