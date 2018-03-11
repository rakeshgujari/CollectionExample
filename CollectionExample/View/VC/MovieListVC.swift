//
//  MovieListVC.swift
//  CollectionExample
//
//  Created by Rakesh Gujari on 11/03/18.
//  Copyright © 2018 Rakesh Gujari. All rights reserved.
//

import UIKit

class MovieListVC: UIViewController {

    @IBOutlet weak var movieCollection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    var id : NSNumber?
    var sortBy : [String] = ["Most Popular", "Highest Rated"]
    var picker = UIPickerView()
    var sortText : String = "Most Popular"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movie Browser"
        self.configurePicker()
        
        let navBtn = UIBarButtonItem(title: "Sort By", style: .plain, target: self, action: #selector(showSortOptions))
        self.navigationItem.rightBarButtonItem = navBtn
        
        self.resetValues()
        self.getPopularMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func configurePicker() {
        self.picker.frame = CGRect(x: 0, y: Constants.ScreenDimensions.height-200, width: Constants.ScreenDimensions.width, height: 200)
        self.picker.showsSelectionIndicator = true
        self.picker.backgroundColor = UIColor.lightGray
        self.picker.delegate = self
        self.picker.dataSource = self
        self.view.addSubview(picker)
        self.picker.isHidden = true
    }
    
    @objc func showSortOptions() {
        self.view.endEditing(true)
        self.picker.isHidden = false
    }
    
    ///Sort list of movies and clears search results if present
    func sortList(_ reset: Bool? = true) {
        self.picker.isHidden = true
        searchBar.text = ""
        if reset! {
            resetValues()
        }
        switch sortText {
        case sortBy[0]:
            getPopularMovies()
            break
        default:
            getTopRatedMovies()
            break
        }
        
    }
    
    func resetValues() {
        ViewModel.default.movies = []
        self.movieCollection.reloadData()
        ViewModel.default.pageNumber = 1
    }
    
    func getPopularMovies() {
        AppHelper.context.showLoader()
        ViewModel.default.getMovies(searchStr: "", urlStr: Constants.URL.getPopularMovies) { (result) in
            AppHelper.context.removeLoader()
            self.movieCollection.isHidden = false
            if (result) {
                self.movieCollection.reloadData()
            }
        }
    }
    
    func getTopRatedMovies() {
        AppHelper.context.showLoader()
        ViewModel.default.getMovies(searchStr: "", urlStr: Constants.URL.getTopRatedMovies) { (result) in
            AppHelper.context.removeLoader()
            self.movieCollection.isHidden = false
            if (result) {
                self.movieCollection.reloadData()
            }
        }
    }
    
    func search(str : String) {
        AppHelper.context.showLoader()
        self.movieCollection.isHidden = true
        ViewModel.default.getMovies(searchStr: str) { (resultBool) in
            AppHelper.context.removeLoader()
            self.movieCollection.isHidden = false
            if (resultBool) {
                self.movieCollection.reloadData()
            }
        }
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "MovieDetailsVCSegue") {
            let destination = segue.destination as! MovieDetailsVC
            destination.id = self.id
            self.id = nil
        }
    }
 

}

//MARK: - UICollectionViewDelegate
extension MovieListVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        id = ViewModel.default.movies[indexPath.row].id!
        self.performSegue(withIdentifier: "MovieDetailsVCSegue", sender: self)
    }
}

//MARK: - UICollectionViewDataSource
extension MovieListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ViewModel.default.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieCell
        let movie = ViewModel.default.movies[indexPath.row]
        cell.posterImage.loadImage(Constants.URL.imageEndPoint+movie.poster!)
        cell.title.text = movie.title!
        
        if(indexPath.row == ViewModel.default.movies.count-2 && ViewModel.default.movies.count < (ViewModel.default.totalMoviesCount ?? 0)) {
            if searchBar!.text! != "" {
                self.search(str: searchBar!.text!)
            } else {
                sortList(false)
            }
        }
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension MovieListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.ScreenDimensions.width/2-10, height: Constants.ScreenDimensions.width/2+100)
    }
}

//MARK: - Search delegate
extension MovieListVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //        searchBar.showsCancelButton = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //        searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        resetValues()
        if(searchText.count>1) {
            self.search(str: searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        resetValues()
        if(searchBar.text!.count > 1) {
            self.search(str: searchBar.text!)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}

//MARK: - UIPickerViewDelegate
extension MovieListVC: UIPickerViewDelegate {
    
}

//MARK: - UIPickerViewDataSource
extension MovieListVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortBy.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortBy[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sortText = sortBy[row]
        self.sortList()
    }
}


