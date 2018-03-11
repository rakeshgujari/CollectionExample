//
//  MovieDetailsVC.swift
//  CollectionExample
//
//  Created by Rakesh Gujari on 11/03/18.
//  Copyright © 2018 Rakesh Gujari. All rights reserved.
//

import UIKit

class MovieDetailsVC: UIViewController {

    var id : NSNumber?
    var scrollView : UIScrollView?
    var container : UIView?
    var width = Constants.ScreenDimensions.width
    let height = Constants.ScreenDimensions.height
    let valueFont = UIFont.systemFont(ofSize: 12, weight: .regular)
    let helper = AppHelper.context
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        getInfo()
    }
    
    func getInfo() {
        helper.showLoader()
        ViewModel.default.getMovieInfo(id: id!.stringValue) { (result) in
            self.helper.removeLoader()
            if(result) {
                self.createView(data: ViewModel.default.movieData!)
            } else {
                AppHelper.context.showAlert(with: "Failed to load movie details")
            }
        }
    }
    
    func createView(data : NSDictionary) {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        container = UIView(frame: scrollView!.frame)
        scrollView?.addSubview(container!)
        
        let poster = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: width/2+50))
        poster.loadImage(Constants.URL.imageEndPoint+(data.object(forKey: "poster_path") as? String ?? ""))
        poster.contentMode = .scaleAspectFit
        container?.addSubview(poster)
        
        let x : CGFloat = 16
        var y : CGFloat = poster.frame.size.height+16
        width = width-32
        
        let titleHeight = helper.getLabelHeight(text: data.object(forKey: "title") as? String ?? "", font: UIFont.boldSystemFont(ofSize: 15), width: width)
        let title = UILabel(frame: CGRect(x: x, y: y, width: width, height: titleHeight))
        title.text = data.object(forKey: "title") as? String ?? ""
        title.font = UIFont.boldSystemFont(ofSize: 15)
        title.numberOfLines = 0
        title.lineBreakMode = .byWordWrapping
        container?.addSubview(title)
        
        y = y+titleHeight+16
        
        let plotHeader = UILabel(frame: CGRect(x: x, y: y, width: width, height: 20))
        plotHeader.text = "A plot synopsis:"
        plotHeader.font = valueFont
        container?.addSubview(plotHeader)
        
        y = y+28
        
        let plotHeight = helper.getLabelHeight(text: data.object(forKey: "overview") as? String ?? "", font: valueFont, width: width)
        let plot = UILabel(frame: CGRect(x: x, y: y, width: width, height: plotHeight))
        plot.text = data.object(forKey: "overview") as? String ?? ""
        plot.font = valueFont
        plot.numberOfLines = 0
        plot.lineBreakMode = .byWordWrapping
        container?.addSubview(plot)
        
        y = y+plotHeight+10
        
        let rating = UILabel(frame: CGRect(x: x, y: y, width: width, height: 20))
        rating.text = "Rating: \((data.object(forKey: "vote_average") as? NSNumber)?.stringValue ?? "-")"
        rating.font = valueFont
        container?.addSubview(rating)
        
        y = y+28
        
        let release = UILabel(frame: CGRect(x: x, y: y, width: width, height: 20))
        release.text = "Release Date: \((data.object(forKey: "release_date") as? String) ?? "")"
        release.font = valueFont
        container?.addSubview(release)
        
        scrollView?.contentSize = CGSize(width: container!.frame.size.width, height: y+20)
        self.view.addSubview(scrollView!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
