//
//  TweetViewController.swift
//  Twitter
//
//  Created by Ruchit Mehta on 10/29/16.
//  Copyright © 2016 Dhara Bavishi. All rights reserved.
//

import UIKit
import MBProgressHUD
protocol TweetViewControllerDelegate {
    func hamburgerIconClicked()
}
class TweetViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,TweetsDetailViewControllerDelegate,ComposeTweetViewControllerDelegate,UIScrollViewDelegate {
    

    @IBOutlet var tapGestureOnImage: UITapGestureRecognizer!
    
    @IBOutlet weak var tableView: UITableView!
    var tweets : [Tweet]!
    var mentions : [Tweet]!
    let refreshControl = UIRefreshControl()
    var isMoreDataLoading = false
    var selectedMenu = 1
    var delegate : TweetViewControllerDelegate?
    
    //var loadingMoreView:InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpPullToRefresh()
        setUpTableView()
        setUpNavigationBar()
        getRefreshTweetsMentions(isHud: true, callBothMehods: true)
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        
        setUpNavigationTitle()
        self.tableView.reloadData()
        
        
        
    }
    func setUpPullToRefresh(){
        
       
        refreshControl.addTarget(self, action: #selector(self.refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    func getRefreshTweetsMentions(isHud : Bool, callBothMehods:Bool){
        
        if(isHud){
            addHud()
        }
       
        if(selectedMenu == 1 || callBothMehods){
         
                TwitterClient.sharedInstance.homeTimeline(success: { (tweets : [Tweet]) in
                
                
                self.tweets = tweets
                self.tableView.reloadData()
                self.dismissHud()
                
                
                
            }) { (error : Error) in
                
                self.dismissHud()
                
            }

        }
        if(selectedMenu == 2 || callBothMehods){
           
            TwitterClient.sharedInstance.getMentions(success: { (mentions : [Tweet]) in
                
                
                self.mentions = mentions
                self.tableView.reloadData()
                self.dismissHud()
                
            }) { (error : Error) in
                
                self.dismissHud()
                
            }
        }
        
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        
         let indexPath = tableView.indexPath(for: sender.view?.superview?.superview as! UITableViewCell)!
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
        
        
        profileViewController.user = tweets[indexPath.row].user
        
       
       
        present(profileViewController, animated: true) {
        }

        
        
        
    }
    func setUpNavigationBar(){
        navigationController?.navigationBar.barTintColor = UIColor.white
        //UIColor.init(colorLiteralRed: 51.0/255.0, green: 145.0/255.0, blue: 236.0/255.0, alpha: 1)
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 2, width: 30 , height: 30))
//        imageView.contentMode = UIViewContentMode.center
//        let imageName = UIImage(named: "navTitle")
//        imageView.image = imageName
//        self.navigationItem.titleView = imageView
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        print("here is muenu selectd \(selectedMenu)")

        
    }
    func setUpNavigationTitle(){
        if(selectedMenu == 1){
            
            self.title = "Timeline"
        }else{
            self.title = "Mentions"
        }

    }
    func setUpTableView(){
        self.tableView.estimatedRowHeight = 550
        self.tableView.rowHeight = UITableViewAutomaticDimension

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (selectedMenu == 1){
            if (self.tweets) != nil{
                
                return self.tweets.count
            }
            else{
                return 0
            }
        }else{
            if (self.mentions) != nil{
                
                return self.mentions.count
            }
            else{
                return 0
            }
        }
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetsCell", for: indexPath) as! TweetsCell
        cell.profileImageView.isUserInteractionEnabled = true
        tapGestureOnImage.numberOfTapsRequired = 1
       
        cell.profileImageView.addGestureRecognizer(tapGestureOnImage)
        if (selectedMenu == 1){
             cell.tweet = self.tweets[indexPath.row]
        }else{
             cell.tweet = self.mentions[indexPath.row]
        }
       
        return cell
    }
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        getRefreshTweetsMentions(isHud: false, callBothMehods: false)
    }
    
    func addHud(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    func dismissHud(){
        MBProgressHUD.hide(for: self.view, animated: true)
        self.refreshControl.endRefreshing()
    }
    //MARK: IBACTIONS
    @IBAction func onMenuClick(_ sender: AnyObject) {
        
         NotificationCenter.default.postNotification(event: HamburgerEvent.ToggleMenu)
        
    }
    
     @IBAction func onComposeNewTweet(_ sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let composeTweetViewController = storyboard.instantiateViewController(withIdentifier: "composeTweetViewController") as! ComposeTweetViewController
        composeTweetViewController.delegate = self
        present(composeTweetViewController, animated: true) {
        }
     }
    
       
    @IBAction func replyClick(_ sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let composeViewController = storyboard.instantiateViewController(withIdentifier: "composeTweetViewController") as! ComposeTweetViewController
       
        let indexPath = tableView.indexPath(for: sender.superview??.superview as! UITableViewCell)!
        let tweet = tweets[indexPath.row]
        composeViewController.tweet = tweet
        composeViewController.delegate = self
        present(composeViewController, animated: true) {
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "tweetVCDetailSegue") {
            let tweetDetailsViewController = segue.destination as! TweetsDetailViewController
           
            let cell = sender as! TweetsCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet : Tweet
            if(selectedMenu == 1){
                 tweet = tweets[(indexPath! as NSIndexPath).row]
                tweetDetailsViewController.title = "Timeline"
                
            }else{
                tweet = mentions[(indexPath! as NSIndexPath).row]
                tweetDetailsViewController.title = "Mentions"
            }
            tweetDetailsViewController.tweet = tweet
            tweetDetailsViewController.delegate = self
            
            
        }
    }
    //MARK: Detail delegate
    func reloadDataFromDetail(tweet: Tweet){
        
        self.tableView.reloadData()
    }
    func fromComposeTweet(tweet: Tweet){
        
        self.tweets.insert(tweet, at: 0)
        self.tableView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                
                isMoreDataLoading = true
                
                // Code to load more results
                //loadMoreData()
            }
        }
    }
    
    
    
    //    func setupScrollViewIndicator(){
    //        // Set up Infinite Scroll loading indicator
    //        let frame = CGRect(origin: CGPoint (x : 0, y : tableView.contentSize.height),size : CGSize( width : tableView.bounds.size.width,height : InfiniteScrollActivityView.defaultHeight))
    //        loadingMoreView = InfiniteScrollActivityView(frame: frame)
    //        loadingMoreView!.isHidden = true
    //        tableView.addSubview(loadingMoreView!)
    //
    //        var insets = tableView.contentInset;
    //        insets.bottom += InfiniteScrollActivityView.defaultHeight;
    //        tableView.contentInset = insets
    //    }

//    func loadMoreData() {
//        
//        TwitterClient.sharedInstance.loadMoreHomeTimeline(params: Int64.max, success: { (newTweets : [Tweet]) in
//            
//            self.tweets.append(contentsOf: newTweets)
//            self.tableView.reloadData()
//            
//            // Update flag
//            self.isMoreDataLoading = false
//            
//            // Stop the loading indicator
//            self.loadingMoreView!.stopAnimating()
//            
//        }) { (error : Error) in
//            
//        }
//    }

}
