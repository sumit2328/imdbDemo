//
//  HomeVC.swift
//  IMDB Demo
//
//  Created by Sumit on 01/07/24.
//

import UIKit

class HomeVC: UIViewController {

    let viewModel = MovieViewModel()

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var ImdbCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        //viewModel.getMovieByTitle(title: "spiderman")

        let cellNib = UINib(nibName: "HomeDataCell", bundle: nil)
        ImdbCollectionView.register(cellNib, forCellWithReuseIdentifier: "HomeDataCell")
        searchBar.delegate = self
        searchBar.placeholder = "Search here"
        searchBar.searchTextField.textColor = UIColor.white
        searchBar.layer.cornerRadius = 10.0
        searchBar.layer.masksToBounds = true
        observeEvent()
        // Do any additional setup after loading the view.
    }

    func observeEvent(){
        

    self.viewModel.eventHandler = { [weak self] event in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch event {
                case .loading:
                    CustomLoader.shared.showLoader(in: self.view)
                    print("Product loading....")
                    
                case .stopLoading:
                    print("Stop loading...")
                    CustomLoader.shared.hideLoader(from: self.view)
                    
                case .dataLoaded:
                    print("Data loaded...")
                    self.ImdbCollectionView.reloadData()
                    
                case .error(let error):
                    print(error)
                    
                case .newProductAdded(let responseModel):
                    print(responseModel)
                    
                    if let response = self.viewModel.model, response.Search == nil {
                        self.showToast("Movie not found!")
                    }
                    
                case .errorModel(let apiError):
                    self.showToast(apiError?.Error ?? "")
                }
            }
        }

    }
    
    
    
    @IBAction func savedMoviesBtn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SavedMoviesVC") as! SavedMoviesVC
        
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
        
    }
    
    
    
}


// omdb get api https://www.omdbapi.com/?t=joker&apikey=bd447c79


extension HomeVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        
        
        return self.viewModel.model?.Search?.count ?? 0
        
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeDataCell", for: indexPath) as! HomeDataCell
        
        let dict = self.viewModel.model?.Search?[indexPath.item]
        
        cell.titleTxt.text = dict?.Title
        cell.releaseYearTxt.text = dict?.Year
       // cell.posterImg.image

//        if let url = URL(string: dict?.Poster ?? "") {
//            cell.posterImg.setImage(from: url, placeholder: UIImage(named: "placeholder"))
//        }

    
        let urlString = dict?.Poster ?? ""
        if let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: urlString) {
            // Use the 'url' variable for your request
            cell.posterImg.setImage(from: url, placeholder: UIImage(named: "imdbLogo"))

        }
        cell.saveBtn.tag = indexPath.row
        cell.saveBtn.addTarget(self, action: #selector(saveData), for: .touchUpInside)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: ((collectionView.frame.size.width-10)/2), height: 280)
        
        // (collectionView.frame.size.height)/4)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailPageVC") as! DetailPageVC
        
        vc.imdbId = self.viewModel.model?.Search?[indexPath.item].imdbID
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
        
    }
    

    @objc func saveData(Sender:UIButton){
        
        let dict = self.viewModel.model?.Search?[Sender.tag]

        print(dict?.Poster,dict?.Title, dict?.Year)
        
        MovieManager.shared.saveMovie(imageUrl: dict?.Poster ?? "", title: dict?.Title ?? "", year: dict?.Year ?? "", imdbId: dict?.imdbID ?? "")

        
        DispatchQueue.main.async {
            self.showToast("Saved")
        }
        
        
    }
    
    
    
}
extension HomeVC: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
        
        // Perform the search
        if SearchValidator.isValidSearchText(searchBar.text) {
            search(for: searchBar.text!)
        } else {
            self.showToast("Please enter movie name")
        }
    }
    
    private func search(for query: String) {
        // Your search implementation
        print("Searching for \(query)")
        
        
        viewModel.getMovieByTitle(title: query)

        // For example, make a network request or filter data
    }
}
