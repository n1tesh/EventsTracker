//
//  EventListCollectionViewCell.swift
//  EventTracker App
//
//  Created by Nitesh on 22/03/22.
//

import UIKit

class EventListCollectionViewCell: UICollectionViewCell {
    static let identifier = "EventListCell"

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    
    var event: Event!{
        didSet{
            self.eventNameLabel.text = event.name
            self.eventLocationLabel.text = event.place
            self.eventImageView.downloadImageFrom(link: event.imageURL)

        }
    }
    
}
