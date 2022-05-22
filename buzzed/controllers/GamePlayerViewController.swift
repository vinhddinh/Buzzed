//
//  GamePlayerViewController.swift
//  buzzed
//
//  Created by Danielle Alota on 11/5/22.
//

import UIKit

class GamePlayerViewController: HandlerViewController {
    var buzzed: Bool = false
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var buttonImage: UIImageView!
    @IBAction func buttonDown(_ sender: Any) {
        if !buzzed {
            lockBuzzer(wasFirst: true)
            
            // Make call to the host that this peer buzzed in
            print("\(mpcHandler.session.connectedPeers)")
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
    
    override func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("Player received message: " + String(data: data, encoding: .utf8)!)
        //if let serverMessage: [String: Int] = [:]
        let decoder = JSONDecoder()
        do {
            var players = try decoder.decode([String: Int].self, from: data)
            
            for player in players {
                print("This is: " + UIDevice.current.name + ", Compared: " + player.key)
                if player.key == UIDevice.current.name {
                    // Update score UI element so that it's text equals player.value
                    print("Yo, what? It worked!")
                }
            }
        }
        catch let error as NSError {
            // Handle error
            print(error.localizedDescription)
        }
        if let serverMessage = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async { [unowned self] in
                if (serverMessage == "LOCKBUZZERS")
                {
                    print("Player received lock message from host")
                    if (!buzzed) {
                        lockBuzzer(wasFirst: false)
                    }
                }
                else if (serverMessage == "RESETBUZZERS")
                {
                    resetBuzzer()
                }
            }
        }
    }
>>>>>>> Stashed changes

    override func viewDidLoad() {
        super.viewDidLoad()

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
