//
//  MovieDetailsViewController.swift
//  RottenTomatoes
//
//  Created by michelle johnson on 8/29/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var synopsisLabel: UILabel!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        
        // Do any additional setup after loading the view.
        
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["synopsis"] as? String
        
        
        //not the best practice to force down but for now it's ok
        var stringURL = movie.valueForKeyPath("posters.detailed") as! String
        var range = stringURL.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        if let range = range {
            stringURL = stringURL.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        println(stringURL)
        let hiresurl = NSURL(string: stringURL)!
        bgImageView.setImageWithURL(hiresurl)
        
        self.navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
