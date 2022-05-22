//
//  HomeViewController.swift
//  buzzed
//
//  Created by Danielle Alota on 11/5/22.
//

import UIKit
import MultipeerConnectivity

var mcSession: MCSession!

class HomeViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate {
    let peerID = MCPeerID (displayName: UIDevice.current.name)
    var browser: MCBrowserViewController!
    var advertiser: MCAdvertiserAssistant?
    let gameHostVC = GameHostViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupConnectivity()
    }
    
    func setupConnectivity(){
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
    }
    
    @IBAction func joinButtonPressed(_ sender: Any) {
        browser = MCBrowserViewController(serviceType: "buzzed", session: mcSession)
        browser.delegate = self
        self.present(browser, animated: true, completion: nil)
    }
    
    
    @IBAction func hostButtonPressed(_ sender: Any) {
        self.advertiser = MCAdvertiserAssistant(serviceType: "buzzed", discoveryInfo: nil, session: mcSession)
        self.advertiser?.start()
    }
    
    /*** Lots of MultipeerConnectivity functions **/
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "GamePlayer") as! GamePlayerViewController
        gameVC.modalPresentationStyle = .fullScreen
        self.present(gameVC, animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch(state){
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            print(session.connectedPeers.count)
            gameHostVC.createPlayer(name: peerID.displayName)
            gameHostVC.fetchPlayers() //Doesn't seem to be updating the table automatically...?
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not connected: \(peerID.displayName)")
            
        default: print("Connection states default error.")
            
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //         Get the new view controller using segue.destination.
        //         Pass the selected object to the new view controller.
        if segue.destination is GamePlayerViewController {
            _ = segue.destination as? GamePlayerViewController
            
        }
    }
    
    
}
