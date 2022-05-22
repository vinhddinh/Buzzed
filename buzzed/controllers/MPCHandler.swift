 //
 //  MPCHandler.swift
 //  TicTacToe
 //
 //  Created by Vinh Dinh on 18/05/2022.
 //
 
 import UIKit
 import MultipeerConnectivity
 
// var mpcHandler = MPCHandler.handler
 
 class MPCHandler: NSObject {
    
    var handler = MPCHandler()
    let peerID = MCPeerID (displayName: UIDevice.current.name)
    var session: MCSession!
    var browser: MCBrowserViewController!
    var advertiser: MCAdvertiserAssistant?
    var delegate: MPCHandlerDelegate?
    
    override init() {
        super.init()
        setupSession()
    }
    
    func setupSession() {
        session = MCSession(peer: peerID)
        session.delegate = self
    }
    
    func setupBrowser() {
        browser = MCBrowserViewController(serviceType: "Buzzed", session: session)
    }
    
    func advertiseSelf(advertise: Bool) {
        guard advertise else {
            advertiser?.stop()
            advertiser = nil
            return
        }
        advertiser = MCAdvertiserAssistant(serviceType: "Buzzed", discoveryInfo: nil, session: session)
        advertiser?.start()
    }
    
 }
 
 protocol MPCHandlerDelegate {
    func changed(state: MCSessionState, of peer: MCPeerID)
    func received(data: Data, from peer: MCPeerID)
 }
 
 
 // MARK: - MCSessionDelegate
 extension MPCHandler: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        if (state == MCSessionState.connected) {
            print("Connected")
        }
        DispatchQueue.main.async {
            self.delegate?.changed(state: state, of: peerID)
        }
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        return certificateHandler(true)
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            self.delegate?.received(data: data, from: peerID)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
 }
