//
//  GameHostViewController.swift
//  buzzed
//
//  Created by Danielle Alota on 11/5/22.
//

import UIKit
import CoreData
import MultipeerConnectivity

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
                        do {
                            // Broadcast message for players to lock buzzers
                            try mpcHandler.session.send(Data("LOCKBUZZERS".utf8), toPeers: mpcHandler.session.connectedPeers, with: .reliable)
                            print("Host sent lock message to peers")
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
    @IBOutlet weak var tableView: UITableView!
    var playerName: String = ""
    //    var playerIndex: Int = 0
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var players:[PlayerMO]? //player managed object
    
    // Height of each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    // Must change to number of players connected
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = players?.count {
            return count
        }
        return 1
        //        return players?.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomTableViewCell
        let player = self.players?[indexPath.row]
        
        cell.deviceNameLabel?.text = player?.deviceName
        if let points = player?.pointsScored {
            cell.pointsLabel?.text = String(points)
        }
        cell.addButton.tag = indexPath.row //TODO: point system adding
        cell.addButton.addTarget(self, action: #selector(rowWasTapped(sender:)), for: .touchUpInside)
        //        figures out what row the button was tapped in
        return cell
    }
    
    @objc
    func rowWasTapped(sender: UIButton){
        let rowIndex: Int = sender.tag
        let playerSelected = self.players?[rowIndex]
        if let name = playerSelected?.deviceName{
            print(name)
        }
        playerSelected?.pointsScored += 1
//        print(playerSelected?.pointsScored)
        self.fetchPlayers()
    }
    
    /***************
     Core Data Functions
     ************************/
    func fetchPlayers(){
        do{
            let request = PlayerMO.fetchRequest() as NSFetchRequest<PlayerMO>
            let sortByScore = NSSortDescriptor(key: "pointsScored", ascending: false)
            request.sortDescriptors = [sortByScore]
            
            self.players = try context.fetch(request)
            DispatchQueue.main.async {
                if let tableview = self.tableView{
                    tableview.reloadData()
                }
            }
        } catch {
            print("Error in fetching players")
        }
    }
    
    @IBAction func testPopulateButtonPressed(_ sender: Any) {
        self.fetchPlayers()
    }

    func createPlayer(name: String){
        let newPlayer = PlayerMO(context: self.context)
        newPlayer.deviceName = name
        newPlayer.pointsScored = 0
        
        //save object
        do{
            try self.context.save()
            self.fetchPlayers()
        } catch {
                print("Error in saving player object")
            }
    }
    
    /* UI Functions */
    //Spawns in confirmEndView
    @IBAction func endGameButtonPressed(_ sender: Any) {
        confirmEndView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.5) //width is 90% screen and height is 50% height
        blurView.bounds = self.view.bounds;
        animateIn(view: blurView);
        animateIn(view: confirmEndView);
    }
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        mpcHandler.advertiseSelf(advertise: false)
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
        mpcHandler.currentView? = self
    }
    
    
    //For testing purposes, this currently deletes all player data.
    //For deployment, this should reset all points to 0
    @IBAction func resetButtonPressed(_ sender: Any) {
        let request = PlayerMO.fetchRequest() as NSFetchRequest<PlayerMO>
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do{
            if let result = try? context.fetch(request){
                for player in result {
                    context.delete(player)
                }
            }
            try context.save()
        } catch {
            
        }
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
