//
//  ViewController.swift
//  Tube
//
//  Created by Arnaud Benard on 08/06/2014.
//  Copyright (c) 2014 Nono. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var tableView: UITableView!
    var tableViewData = []
    var data: NSMutableData = NSMutableData()

    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView = UITableView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height), style: UITableViewStyle.Plain)
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.view.addSubview(self.tableView)
        fetchTubeData()
        
    }

    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count;
    }
    

    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let myNewCell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        

//        let myNewCell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as UITableViewCell
        println(tableViewData)

        myNewCell.text = tableViewData[indexPath.row] as String
        
        return myNewCell
    }
    
    func fetchTubeData(){
    
        var urlPath = "http://localhost:4567/status"
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)
        
        connection.start()
    }
    
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        // Recieved a new request, clear out the data object
        self.data = NSMutableData()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        // Append the recieved chunk of data to our data object
        self.data.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        // Request complete, self.data should now hold the resulting info
        // Convert the retrieved data in to an object through JSON deserialization
        var err: NSError
        
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(self.data, options:NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        
        if jsonResult.count>0 && jsonResult["result"].count>0 {
            var results: NSArray = jsonResult["result"] as NSArray
            self.tableViewData = results
            self.tableView.reloadData()
        }
    }
    
}
