//
//  SwipeRecognizer.swift
//  EventTracker App
//
//  Created by Nitesh on 23/03/22.
//

import Foundation
import UIKit

protocol SwipeRecognizer: UIViewController {
    func screenEdgeDidSwiped()
}

fileprivate extension UIViewController {
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        guard let swipeRecognizerSelf = self as? SwipeRecognizer else {
                return
        }
        if recognizer.state == .recognized {
//                print("Screen edge swiped!")
            swipeRecognizerSelf.screenEdgeDidSwiped()
        }
    }
}


extension SwipeRecognizer{
    
    func addEdgeSwipe(){
//            print("adding swipe")
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .right
        view.addGestureRecognizer(edgePan)
    }
    
}
