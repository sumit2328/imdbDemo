//
//  DetailPageVC.swift
//  IMDB Demo
//
//  Created by Sumit on 01/07/24.
//

import UIKit

class DetailPageVC: UIViewController {
    
    
    var imdbId : String?
    
    let viewModel = DetailsPageViewModel()
    
    @IBOutlet weak var releaseYearTxt: UILabel!
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var titleTxt: UILabel!
    
    @IBOutlet weak var ratingTxt: UILabel!
    @IBOutlet weak var castTxt: UILabel!
    
    @IBOutlet weak var descTxt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getMovieDetailsById(id: imdbId ?? "")
        
        observeEvent()
        // Do any additional setup after loading the view.
    }
    
    
    func observeEvent(){
        
        DispatchQueue.main.async {
            CustomLoader.shared.showLoader(in: self.view)
        }
        
        self.viewModel.eventHandler = { [weak self] event in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                

                switch event {
                case .loading:
                    print("Product loading....")

                case .stopLoading:
                    CustomLoader.shared.hideLoader(from: self.view)
                    print("Stop loading...")
                    
                case .dataLoaded:
                    print("Data loaded...")
                    self.titleTxt.text = self.viewModel.model?.Title
                    self.ratingTxt.text = "Imdb Rating : \(self.viewModel.model?.imdbRating ?? "")"
                    self.releaseYearTxt.text = "Release Year : \(self.viewModel.model?.Year ?? "")"
                    self.castTxt.text = self.viewModel.model?.Actors
                    self.descTxt.text = self.viewModel.model?.Plot
                    
                    if let urlString = self.viewModel.model?.Poster,
                       let url = URL(string: urlString) {
                        self.posterImg.setImage(from: url, placeholder: UIImage(named: "imdbLogo"))
                    }
                    
                case .error(let error):
                    print(error)
                    
                case .newProductAdded(let responseModel):
                    print(responseModel)
                    
//                    if let response = self.viewModel.model, response.Search == nil {
//                        self.showToast("Movie not found!")
//                    }
                }
            }
        }
        
    }

    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
        
    }
    
}
