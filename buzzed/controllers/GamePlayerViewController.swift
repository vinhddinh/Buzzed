//
//  GamePlayerViewController.swift
//  buzzed
//
//  Created by Danielle Alota on 11/5/22.
//

import UIKit
import MultipeerConnectivity

class GamePlayerViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    var buzzed: Bool = false
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var buttonImage: UIImageView!
    @IBAction func buttonDown(_ sender: Any) {
        if !buzzed {
            lockBuzzer()
            
            // Make call to the host that this peer buzzed in
            if mpcHandler.session.connectedPeers.count > 0 {
                do {
                    // Broadcast peer ID for host to receive
                    try mpcHandler.session.send(Data(UIDevice.current.name.utf8), toPeers: mpcHandler.session.connectedPeers, with: .reliable)
                    print("Client sent buzz to host")
                } catch let error as NSError {
                    // Handle error
                    print(error.localizedDescription);
                }
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("Player received message")
        if let serverMessage = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async { [unowned self] in
                if (serverMessage == "LOCKBUZZERS")
                {
                    print("Player received lock message from host")
                    lockBuzzer()
                }
                else if (serverMessage == "RESETBUZZZERS")
                {
                    resetBuzzer()
                }
            }
        }
    }

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
