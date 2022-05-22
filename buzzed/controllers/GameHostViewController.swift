//
//  GameHostViewController.swift
//  buzzed
//
//  Created by Danielle Alota on 11/5/22.
//

import UIKit

class GameHostViewController: HandlerViewController, UITableViewDelegate, UITableViewDataSource {
    override func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("Host received message: " + String(data: data, encoding: .utf8)!)
        if let playerName = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async { [unowned self] in
                if (playerName != "LOCKBUZZERS")
                {
                    // TODO: Identify player with name playerName as having buzzed in first
                    print("Host received buzz")

                    // Tell all players to lock their buzzers
                    if mpcHandler.session.connectedPeers.count > 0 {
                        print("Host sending lock message to peers")
                        do {
                            try mpcHandler.session.send(Data("LOCKBUZZERS".utf8), toPeers: mpcHandler.session.connectedPeers, with: .reliable)
                            } catch let error as NSError {
                                // Handle error
                                print(error.localizedDescription);
                            }
                        
                        print("Host sending score message to peers")
                        do {
                            // Get yourself a handy JSON
                            var playersDictionary: [String: Int] = [:]
                            for player in players! {
                                playersDictionary[player.deviceName!] = Int(player.pointsScored)
                            }
                            let encoder = JSONEncoder()
                            
                            // Broadcast message for players to lock buzzers
                            try mpcHandler.session.send(encoder.encode(playersDictionary), toPeers: mpcHandler.session.connectedPeers, with: .reliable)
                        } catch let error as NSError {
                            // Handle error
                            print(error.localizedDescription);
                        }
                    }
                }
            }
        }
    }
    @IBOutlet var confirmEndView: UIView!
    @IBOutlet var blurView: UIVisualEffectView!
    
    //Spawns in confirmEndView
    @IBAction func endGameButtonPressed(_ sender: Any) {
        confirmEndView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.5) //width is 90% screen and height is 50% height
        blurView.bounds = self.view.bounds;
        animateIn(view: blurView);
        animateIn(view: confirmEndView);
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

        // Do any additional setup after loading the view.
        mpcHandler.currentView? = self // THIS DOESN'T WORK. WHY?!?!?!?!
    }
    
    
    //For testing purposes, this currently deletes all player data.
    //For deployment, this should reset all points to 0
    @IBAction func resetButtonPressed(_ sender: Any) {
        
//        let request = PlayerMO.fetchRequest() as NSFetchRequest<PlayerMO>
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//        do{
//            if let result = try? context.fetch(request){
//                for player in result {
//                    context.delete(player)
//                }
//            }
//            try context.save()
//        } catch {
//
//        }
        self.fetchPlayers()
        // TODO: Probably delete this...
        // Tell all players to unlock their buzzers
        if mpcHandler.session.connectedPeers.count > 0 {
            do {
                // Broadcast message for players to lock buzzers
                try mpcHandler.session.send(Data("RESETBUZZERS".utf8), toPeers: mpcHandler.session.connectedPeers, with: .reliable)
            } catch let error as NSError {
                // Handle error
                print(error.localizedDescription);
            }
        }
>>>>>>> Stashed changes
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
