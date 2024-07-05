//
//  CustomLoader.swift
//  IMDB Demo
//
//  Created by Sumit on 02/07/24.
//



import UIKit

class CustomLoader {
    static let shared = CustomLoader()
    private var activityIndicator: UIActivityIndicatorView!

    private init() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .red
    }

    func showLoader(in view: UIView) {
        DispatchQueue.main.async {
            self.activityIndicator.center = view.center
            view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
            view.isUserInteractionEnabled = false // Optionally disable user interaction
        }
    }

    func hideLoader(from view: UIView) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            view.isUserInteractionEnabled = true // Enable user interaction
        }
    }
}
