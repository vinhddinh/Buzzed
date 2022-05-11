//
//  TestViewController.swift
//  buzzed
//
//  Created by Vinh Dinh on 12/5/2022.
//

import UIKit
import MultipeerConnectivity

class TestViewController : UITableViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
            case .connected: print ("connected \(peerID)")
            case .connecting: print ("connecting \(peerID)")
            case .notConnected: print ("not connected \(peerID)")
            default: print("unknown status for \(peerID)")
          }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {}
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    override func viewDidLoad() {
      peerID = MCPeerID(displayName: UIDevice.current.name)
      mcSession = MCSession(peer: peerID, securityIdentity: nil,    encryptionPreference: .required)
      mcSession.delegate = self
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
      let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default) { (UIAlertAction) in
            self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType:  "testBuzzed", discoveryInfo: nil, session: self.mcSession)
            self.mcAdvertiserAssistant.start()
           })
      ac.addAction(UIAlertAction(title: "Join a session", style: .default) { (UIAlertAction) in
          let mcBrowser = MCBrowserViewController(serviceType: "testBuzzed", session: self.mcSession)
          mcBrowser.delegate = self
          self.present(mcBrowser, animated: true, completion: nil)
         })
      ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
      present(ac, animated: true)
    }}
