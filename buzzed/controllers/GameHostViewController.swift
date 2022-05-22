//
//  GameHostViewController.swift
//  buzzed
//
//  Created by Danielle Alota on 11/5/22.
//

import UIKit
import CoreData

class GameHostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var confirmEndView: UIView!
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet weak var tableView: UITableView!
//    var playerIndex: Int = 0
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var players:[PlayerMO]? //player managed object

    //Height of each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
        //must change to number of players connected
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomTableViewCell
        let player = self.players?[indexPath.row]
        
        
        cell.deviceNameLabel?.text = "iPhone 11"
        cell.pointsLabel?.text = String(0)
        cell.addButton.tag = indexPath.row //TODO: point system adding
        cell.addButton.addTarget(self, action: #selector(rowWasTapped(sender:)), for: .touchUpInside)
//        figures out what row the button was tapped in
        return cell
    }

    @objc
    func rowWasTapped(sender: UIButton){
        let rowIndex: Int = sender.tag
        let playerSelected = self.players?[rowIndex]
        playerSelected?.pointsScored += 1
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
        let newPlayer = PlayerMO(context: self.context)
        newPlayer.deviceName = "Apple"
        newPlayer.pointsScored = 0
        
        //save object
        do{
            try self.context.save()
        } catch {
            print("Error in saving player object")
        }
        
        //refresh the tableview
        self.fetchPlayers()
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
        mpcHandler.advertiser?.stop()
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
        mpcHandler.setupPeerWithDisplayName(displayName: UIDevice.current.name)
        mpcHandler.setupSession()
        mpcHandler.advertiseSelf(advertise: true)
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
