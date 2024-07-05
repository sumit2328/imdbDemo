//
//  SavedMoviesVC.swift
//  IMDB Demo
//
//  Created by Sumit on 02/07/24.
//

import UIKit

class SavedMoviesVC: UIViewController {

    @IBOutlet weak var savedMovieCollectionView: UICollectionView!
    
    
    var movies: [Movies]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let cellNib = UINib(nibName: "HomeDataCell", bundle: nil)
        savedMovieCollectionView.register(cellNib, forCellWithReuseIdentifier: "HomeDataCell")
        
         movies = MovieManager.shared.fetchMovies()
        
        
//        for movie in movies {
//            print("Title: \(movie.title ?? ""), Year: \(movie.year ?? ""), Image URL: \(movie.imageUrl ?? "")")
//        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtn(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    
}


extension SavedMoviesVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      if movies?.count == 0 {
        // No movies found, display a placeholder label
        let label = UILabel(frame: collectionView.bounds)
        label.text = "No saved movies found"
        label.textColor = .white // Set text color to white
        label.textAlignment = .center
        label.backgroundColor = .clear // Transparent background
        collectionView.backgroundView = label
        return 0
      } else {
        // Movies found, return actual item count
        collectionView.backgroundView = nil // Remove placeholder label
        return movies?.count ?? 0
      }
    }

    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeDataCell", for: indexPath) as! HomeDataCell
        
        let dict = movies?[indexPath.item]
        
        //cell.saveBtn.backgroundColor = .clear
        if (dict?.isFavorite == false){
            
            let image = UIImage(systemName: "heart")
            cell.saveBtn.setImage(image, for: .normal)
            cell.saveBtn.tintColor = .red
            
        }else{
            let image = UIImage(systemName: "heart.fill")
            cell.saveBtn.setImage(image, for: .normal)
            cell.saveBtn.tintColor = .systemPink
            
        }
        
        cell.titleTxt.text = dict?.title
        cell.releaseYearTxt.text = dict?.year

        let urlString = dict?.imageUrl ?? ""
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
        
        let dict = movies?[indexPath.item]
        
        vc.imdbId = dict?.imdbId

        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
        
    }
    

    @objc func saveData(sender: UIButton) {
      guard let movies = movies, movies.indices.contains(sender.tag) else {
        // Handle case where movies array is nil or index is out of bounds
        print("Error: Movies array or index is invalid")
        return
      }

      let movie = movies[sender.tag]
        

        
      movie.isFavorite = !movie.isFavorite // Toggle favorite state
      
      let isFavorite = movie.isFavorite  // Store favorite state for toast message
      
      DispatchQueue.main.async {
        self.savedMovieCollectionView.reloadData()
        
        let message: String
        if isFavorite {
          message = "Saved to Favorites"
        } else {
          message = "Removed from Favorites"
        }
        self.showToast(message)
      }
    }
    
    
    
    
    
    
}
