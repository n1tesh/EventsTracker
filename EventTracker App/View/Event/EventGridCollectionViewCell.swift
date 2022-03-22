//
//  EventCollectionViewCell.swift
//  EventTracker App
//
//  Created by Nitesh on 22/03/22.
//

import UIKit

class EventGridCollectionViewCell: UICollectionViewCell {
    static let identifier = "EventGridCell"
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    
    var event: Event!{
        didSet{
            self.eventNameLabel.text = event.name
            self.eventImageView.downloadImageFrom(link: event.imageURL)
        }
    }
    
}
