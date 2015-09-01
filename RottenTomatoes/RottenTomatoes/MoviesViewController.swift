//
//  MoviesViewController.swift
//  RottenTomatoes
//
//  Created by michelle johnson on 8/25/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
     var refreshControl: UIRefreshControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    
    
    var movies: [NSDictionary]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.errorView.layer.zPosition = 2
        
        self.view.backgroundColor = UIColor.blackColor()
        
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.backgroundColor = UIColor.blackColor()
        
        JTProgressHUD.show()
        
        let url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us")!
        let request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            println(error)
            
            
            if (data == nil) {
                self.errorView.hidden = false
            } else {
                println("went here")
                let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
                
                if let json = json {
                    // '?' means try if you can't either wise it's fine if it's nil; '!' force it to downcast
                    self.movies = json["movies"] as? [NSDictionary]
                    self.tableView.reloadData() //tells table view to check source again
                    self.errorView.hidden = true
                    
                    
                }
            }
            JTProgressHUD.hide()
            
            
        }
        
        //sets tableview's data source to be me
        tableView.dataSource = self
        tableView.delegate = self
        
        
        //Colors
        self.navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //uitableviewdelegate requires these funcs
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        //not the best practice to force down but for now it's ok
        var stringURL = movie.valueForKeyPath("posters.detailed") as! String
        var range = stringURL.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        if let range = range {
            stringURL = stringURL.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        
        let hiresurl = NSURL(string: stringURL)!
        
        cell.posterView.setImageWithURL(hiresurl)
        
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        var indexPath = tableView.indexPathForCell(cell)!
        
        let movie = movies![indexPath.row]
        
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
        
        movieDetailsViewController.movie = movie
        
        
        println("i'm about to segue")
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        let url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us")!
        let request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            
            if (data == nil) {
                println("here")
                self.errorView.hidden = false
            } else {
                let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
            
                if let json = json {
                    // '?' means try if you can't either wise it's fine if it's nil; '!' force it to downcast
                    self.movies = json["movies"] as? [NSDictionary]
                    self.tableView.reloadData() //tells table view to check source again
                    self.errorView.hidden = true
                }
            }
        }
        
        //sets tableview's data source to be me
        tableView.dataSource = self
        tableView.delegate = self
        
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
    }


}
