//
//  GamePlayerViewController.swift
//  buzzed
//
//  Created by Danielle Alota on 11/5/22.
//

import UIKit
import MultipeerConnectivity

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
    
    @IBOutlet weak var scoreLabel: UILabel!
    override func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("Player received message: " + String(data: data, encoding: .utf8)!)
        
        let decoder = JSONDecoder()
        do {
            var players = try decoder.decode([String: Int].self, from: data)
            
            for player in players {
                print("This is: " + UIDevice.current.name + ", Compared: " + player.key)
                if player.key == UIDevice.current.name {
                    print("Yo, what? It worked!")
                    scoreLabel.text = "Your score: " + String(player.value)
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

    func lockBuzzer(wasFirst: Bool) {
        buttonImage.image = UIImage(named: "buttonBuzzed.png")
        buzzed = true
        
        if wasFirst {
            buttonImage.alpha = 1.0
        }
        else {
            buttonImage.alpha = 0.2
        }
    }
    
    func resetBuzzer() {
        buttonImage.image = UIImage(named: "buttonBuzz.png")
        buzzed = false
        buttonImage.alpha = 1.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        button.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        mpcHandler.currentView = self
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
