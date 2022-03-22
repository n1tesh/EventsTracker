//
//  UIImageViewExtensions.swift
//  EventTracker App
//
//  Created by Nitesh on 23/03/22.
//

import Foundation
import UIKit

extension UIImageView {
    func downloadImageFrom(link: String) {
        URLSession.shared.dataTask(with: URL(string: link)!) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else { return }
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}
