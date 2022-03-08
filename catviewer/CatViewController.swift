//
//  CatViewController.swift
//  catviewer
//
//  Created by Richard Pickup on 24/01/2015.
//  Copyright (c) 2015 Richard Pickup. All rights reserved.
//

import UIKit


class CatViewController : UIViewController {
    
    var session:URLSession!
    
    @IBOutlet weak var dataImageView: UIImageView!
    
    //let catFactURL = "http://catfacts-api.appspot.com/api/facts?number=5"
    
    let catFactURL = "https://catfact.ninja/fact"
    
    let catGifUrl1 = "http://edgecats.net/"
    
    let catGifUrl2 = "http://thecatapi.com/api/images/get?format=src&type=gif"
    
    let placeholder = "346.GIF"
    
    @IBOutlet weak var factLabel: UILabel!
    
    @IBAction func moreCats(_ sender: UIButton) {
        getCatGif()
        getCatFact()
    }
    
    
    @IBAction func moreCatsBar(_ sender: AnyObject) {
        getCatGif()
        getCatFact()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Kitteh Factz"
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = nil
        let sessionConfig = URLSessionConfiguration.default
        
        session = URLSession(configuration: sessionConfig)
        
        if let filePath = Bundle.main.path(forResource: "346", ofType: "GIF") {
            let data = try? Data(contentsOf: URL(fileURLWithPath: filePath))
            
            if (data != nil) {
                let loadingGif = UIImage.animatedImage(withAnimatedGIFData: data)
                if loadingGif != nil {
                    
                    self.dataImageView.animationImages = loadingGif?.images
                    self.dataImageView.animationDuration = loadingGif?.duration ?? 0
                    self.dataImageView.animationRepeatCount = 0
                    self.dataImageView.image = loadingGif?.images?.last ?? nil
                    self.dataImageView.startAnimating()
                    self.dataImageView.contentMode = .top
                }
            }
            
        }
        getCatGif()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCatFact()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    func getCatFact() {
        guard let url = URL(string: catFactURL) else { return }
        
        let dataTask = session .dataTask(with: url) {
            (data, response, error) in
            
            if error == nil {
                let httpResp = response as! HTTPURLResponse
                
                if httpResp.statusCode == 200 {
                    
                    do{
                        guard let json: NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary else {
                            return
                        }
                        
                        print("json = \(String(describing: json))")
                        
                        let facts = json["fact"] as? String
                        
                        DispatchQueue.main.async {
                            self.factLabel.text = facts ?? ""
                        }
                    }
                    catch {
                        print("Error parsing json")
                    }
                    
                }
            }
        }
        
        dataTask.resume()
    }
    
    func getCatGif() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        guard let imageUrl = URL(string: catGifUrl2) else { return }
        
        
        let getImageTask = session.downloadTask(with: imageUrl) {
            (url, response, error) in
            
            print("\(String(describing: error))")
            do{
                if let url = url {
                    let catGif = try UIImage.animatedImage(withAnimatedGIFData: Data(contentsOf: url))
                    if catGif != nil {
                        
                        DispatchQueue.main.async {
                            self.dataImageView.animationImages = catGif?.images
                            self.dataImageView.animationDuration = catGif?.duration ?? 0
                            self.dataImageView.animationRepeatCount = 0
                            self.dataImageView.image = catGif?.images?.last ?? nil
                            self.dataImageView.contentMode = .scaleToFill
                            self.dataImageView.startAnimating()
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            
                        }
                    }
                }
                
            }
            catch{}
        }
        getImageTask .resume()
    }
    
    
    
    
    
    
    
    
    
}








