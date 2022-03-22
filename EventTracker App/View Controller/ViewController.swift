//
//  ViewController.swift
//  EventTracker App
//
//  Created by Nitesh on 22/03/22.
//

import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func didUpdateTrackedList()
}

class HomeViewController: UIViewController, SwipeRecognizer {
    weak var delegate: HomeViewControllerDelegate?

    @IBOutlet weak var eventsCollectionView: UICollectionView!

    fileprivate var events: [Event] = []{
        didSet{
            self.eventsCollectionView.reloadData()
        }
    }
    
    private let sectionInsets = UIEdgeInsets.init(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    private var isListView = false
    private var toggleButton = UIBarButtonItem()
    private var selectedEvent: Event?
    
    enum EventViewType {
        case allEvents
        case favourites
    }
    
    var viewType: EventViewType = .allEvents
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addEdgeSwipe()
        
        switch viewType {
        case .allEvents:
            self.title = "Events"
            self.events = Event.getMockedData()
            self.toggleButton = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2"), style: .plain, target: self, action: #selector(butonTapped(sender:)))
            self.navigationItem.setRightBarButton(toggleButton, animated: true)
            let favouriteBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "heart.fill"),
                                 style: .done,
                                 target: self,
                                 action: #selector(viewTrackedEventTapped))
            self.navigationItem.leftBarButtonItem = favouriteBarButtonItem
        case .favourites:
            self.title = "Tracked Events"
            self.events = LocalStorageManager.shared.events
        }
       
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        self.eventsCollectionView.setCollectionViewLayout(layout, animated: true)

    }

    @objc private func viewTrackedEventTapped(){
        self.openTrackedEvents()
    }
    
    @objc private func butonTapped(sender: UIBarButtonItem) {
        if self.isListView {
            self.toggleButton = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2"), style: .plain, target: self, action: #selector(butonTapped(sender:)))
            self.isListView = false
        }else {
            self.toggleButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(butonTapped(sender:)))
            self.isListView = true
        }
        self.navigationItem.setRightBarButton(self.toggleButton, animated: true)
        self.eventsCollectionView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.eventsCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showNameAlert()
    }
    
    deinit {
        print("Deinit called ViewController")
    }
    
    private func showNameAlert(){
        guard AppController.shared.name.isWhitespace else {
            return
        }
        let alert = UIAlertController(title: "Enter your name", message: nil, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title:"Save", style: .default, handler: nil)
        saveAction.isEnabled = false
        alert.addAction(saveAction)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Name"
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main) { notification in
                let name = textField.text ?? ""
                saveAction.isEnabled = name.isWhitespace == false
                print("Name: \(name)")
                AppController.shared.name = name
            }
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func screenEdgeDidSwiped() {
        self.openTrackedEvents()
    }
    
    private func openTrackedEvents(){
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HomeViewController") as? HomeViewController{
            vc.viewType = .favourites
            let navController = UINavigationController(rootViewController: vc)
            self.present(navController, animated: true, completion: nil)
        }
    }

}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.events.count == 0) {
            let message = self.viewType == .favourites ? "Please add events to track" : "Nothing to show :("
            self.eventsCollectionView.setEmptyMessage(message)
        } else {
            self.eventsCollectionView.restore()
        }
        return self.events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let gridCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: EventGridCollectionViewCell.identifier, for: indexPath) as! EventGridCollectionViewCell
        let listcollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: EventListCollectionViewCell.identifier, for: indexPath) as! EventListCollectionViewCell
        let event = self.events[indexPath.row]
        gridCollectionCell.event = event
        listcollectionCell.event = event
        return self.isListView ? listcollectionCell : gridCollectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let event = self.events[indexPath.row]
        let eventDetailsTVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "EventDetailsTableViewController") { coder in
            return EventDetailsTableViewController(coder: coder, event: event)
        }
        if viewType == .favourites{
            eventDetailsTVC.delegate = self
        }
        self.navigationController?.pushViewController(eventDetailsTVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        if self.isListView {
            return CGSize(width: width, height: 120)
        }else {
            return CGSize(width: (width - 15)/2, height: (width - 15)/2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}

extension HomeViewController: EventDetailsDelegate{
    
    func didUpdateTrackedList() {
        self.events = LocalStorageManager.shared.events
        self.delegate?.didUpdateTrackedList()
    }
    
}


