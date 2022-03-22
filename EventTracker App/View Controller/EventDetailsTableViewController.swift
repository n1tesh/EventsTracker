//
//  EventDetailsTableViewController.swift
//  EventTracker App
//
//  Created by Nitesh on 22/03/22.
//

import UIKit

protocol EventDetailsDelegate: AnyObject {
    func didUpdateTrackedList()
}

class EventDetailsTableViewController: UITableViewController, SwipeRecognizer {
    weak var delegate: EventDetailsDelegate?

    @IBOutlet weak var eventTypeButton: UIButton!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    var event: Event!
    @IBOutlet weak var trackEventButton: UIButton!
    
    @IBOutlet weak var removeTrackEventButton: UIButton!
    init?(coder: NSCoder, event: Event) {
        self.event = event
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = event.name
        self.addEdgeSwipe()
        self.eventNameLabel.text = event.name
        self.eventLocationLabel.text = event.place
        self.eventImageView.downloadImageFrom(link: event.imageURL)
        self.eventTypeButton.setTitle(event.entryType == .free ? "FREE" : "PAID", for: .normal)
        self.checkEventExistInTracked()

    }
    
    deinit {
        print("Deinit called EventDetailsTableViewController")
    }
    
    fileprivate func checkEventExistInTracked(){
        let eventExistInTracked = LocalStorageManager.shared.checkIfEventExists(event)
        self.removeTrackEventButton.isHidden = !eventExistInTracked
        self.trackEventButton.isHidden = eventExistInTracked
    }
    
    @IBAction func trackEventButtonAction(_ sender: UIButton) {
        if let event = event {
            if LocalStorageManager.shared.addEventToFavourite(event){
                self.showAlert(title: "Added to track list", message: nil, buttonTitles: nil, highlightedButtonIndex: nil, completion: {[weak self] _ in
                    self?.removeTrackEventButton.isHidden = false
                    sender.isHidden = true
                    self?.delegate?.didUpdateTrackedList()
                })
            }
        }
    }
    
    @IBAction func removeTrackEventButtonAction(_ sender: UIButton) {
        if let event = event {
            if LocalStorageManager.shared.removeEventFromFavourite(event){
                self.showAlert(title: "Removed from tracked list", message: nil, buttonTitles: nil, highlightedButtonIndex: nil, completion: {[weak self] _ in
                    self?.trackEventButton.isHidden = false
                    sender.isHidden = true
                    self?.delegate?.didUpdateTrackedList()
                })
            }
        }
    }
    
    func screenEdgeDidSwiped() {
        print("YESSSSS")
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HomeViewController") as? HomeViewController{
            vc.viewType = .favourites
            vc.delegate = self
            let navController = UINavigationController(rootViewController: vc)
            self.present(navController, animated: true, completion: nil)
        }
    }
    
}

extension EventDetailsTableViewController: HomeViewControllerDelegate{
    
    func didUpdateTrackedList() {
        self.checkEventExistInTracked()
    }
    
}
