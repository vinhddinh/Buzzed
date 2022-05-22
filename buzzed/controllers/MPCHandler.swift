//
//  MPCHandler.swift
//  TicTacToe
//
//  Created by Vinh Dinh on 18/05/2022.
//
 
import UIKit
import MultipeerConnectivity
 
var mpcHandler = MPCHandler.handler
//session is mpcHandler.session
 class MPCHandler: NSObject {
    
    static var handler = MPCHandler()
    let peerID = MCPeerID (displayName: UIDevice.current.name)
    var session: MCSession!
    var browser: MCBrowserViewController!
    var advertiser: MCAdvertiserAssistant?
    var delegate: MPCHandlerDelegate?
     
    var currentView: HandlerViewController?
    
    override init() {
        super.init()
        setupSession()
    }
    
    func setupSession() {
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
    }
    
    func setupBrowser() {
        browser = MCBrowserViewController(serviceType: "buzzed", session: session)
    }
    
    func advertiseSelf(advertise: Bool) {
        guard advertise else {
            advertiser?.stop()
            advertiser = nil
            return
        }
        advertiser = MCAdvertiserAssistant(serviceType: "buzzed", discoveryInfo: nil, session: session)
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
        switch(state){
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
        
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not connected: \(peerID.displayName)")
            
        default: print("Connection states default error.")
            
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
            if self.currentView != nil {
                self.currentView?.session(session, didReceive: data, fromPeer: peerID)
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
 }
