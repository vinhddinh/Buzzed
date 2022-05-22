//
//  HandlerViewController.swift
//  buzzed
//
//  Created by Andy Chapman on 23/5/22.
//

import UIKit
import MultipeerConnectivity

class HandlerViewController: UIViewController {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) { }
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) { }
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) { }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) { }
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) { }
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) { }
}
