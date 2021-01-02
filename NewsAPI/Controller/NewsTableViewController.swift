//
//  NewsTableViewController.swift
//  NewsAPI
//
//  Created by Amit Chaudhary on 11/26/20.
//  Copyright © 2020 Amit Chaudhary. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import ChameleonFramework

private let reUseCellIdentifier = "NewsTableCell"

fileprivate let projectString = "https://raw.githubusercontent.com/AxxessTech/Mobile-Projects/master/challenge.json"

class NewsTableViewController: UITableViewController {
    
    let newsHTTPManagerObject = NewsHTTPManager()
    
    var arrayOfDatas = [NewsSwiftData]()
    
    var cellStates: [CellState]?
    
    var contentArray = [Content]()      // we can delete NewsSwiftData and use Content instead of it.
    
    let contentContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let topSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.frame = CGRect.zero
        
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search Here.."
        searchBar.autocapitalizationType = .none
        searchBar.barTintColor = UIColor.flatBlue()
        searchBar.tintColor = UIColor.white
        searchBar.showsCancelButton = false
        searchBar.sizeToFit()
        return searchBar
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: reUseCellIdentifier)
        newsHTTPManagerObject.delegate = self
        
        //read from coredata container
        let request: NSFetchRequest<Content> = Content.fetchRequest()
        do {
            self.contentArray = try contentContext.fetch(request)
        } catch {
            print(error)
        }
        
        if contentArray.count == 0 {
            newsHTTPManagerObject.performHTTPRequest(projectString)
        } else {
            // load from core data persistentcontainer
            //set searchbar
            self.tableView.tableHeaderView = self.topSearchBar
            self.tableView.reloadData()
        }
        
        //searchbar
        self.topSearchBar.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.flatPurple()
        
    }
    
    
    //MARK: - Delegate/ DataSource Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.contentArray.isEmpty {
            return arrayOfDatas.count
        } else {
            return self.contentArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reUseCellIdentifier, for: indexPath) as! NewsTableViewCell
        
        cell.backgroundColor = UIColor.randomFlat()
        
        if self.contentArray.isEmpty {
            
            if let id = arrayOfDatas[indexPath.row].id {
                cell.descriptionLabel.text = id
            }
            
            if let date = arrayOfDatas[indexPath.row].date {
                cell.dateAndTimeLabel.text = date
            }
            
            if let data = arrayOfDatas[indexPath.row].data {
                cell.titleLabel.text = data
            }
            
            
            
            if let type = arrayOfDatas[indexPath.row].type {
                if (type == "image") && (arrayOfDatas[indexPath.row].data!.contains("https://")) {
                    
                    let url = arrayOfDatas[indexPath.row].data
                    
                    // use completionhandler so that we can return cell even before downloaded imagedata is set to cell's newsImageview.
                    let task = URLSession.shared.dataTask(with: URL(string: url!)!) { (data, response, error) in
                        if let safeData = data {
                            let image = UIImage(data: safeData)
                            if let safeImage = image {
                                DispatchQueue.main.async {
                                    if (cell.titleLabel.text!.contains("https://")) {
                                        cell.newsImageView.image = safeImage
                                    }
                                    
                                }
                            }
                        }
                    }
                    task.resume()
                } else {
                    cell.newsImageView.image = #imageLiteral(resourceName: "NoData")
                }
                
            }
            
        } else {
            // load from contentArray (local data persistentcontainer .sqlite)
            if let id = contentArray[indexPath.row].id {
                cell.descriptionLabel.text = id
            }
            
            if let date = contentArray[indexPath.row].date {
                cell.dateAndTimeLabel.text = date
            }
            
            if let data = contentArray[indexPath.row].data {
                cell.titleLabel.text = data
            }
            
            
            
            if let type = contentArray[indexPath.row].type {
                if (type == "image") && (contentArray[indexPath.row].data!.contains("https://")) {
                    
                    let url = contentArray[indexPath.row].data
                    
                    // use completionhandler so that we can return cell even before downloaded imagedata is set to cell's newsImageview.
                    let task = URLSession.shared.dataTask(with: URL(string: url!)!) { (data, response, error) in
                        if let safeData = data {
                            let image = UIImage(data: safeData)
                            if let safeImage = image {
                                DispatchQueue.main.async {
                                    if (cell.titleLabel.text!.contains("https://")) {
                                        cell.newsImageView.image = safeImage
                                    }
                                    
                                }
                            }
                        }
                    }
                    task.resume()
                } else {
                    cell.newsImageView.image = #imageLiteral(resourceName: "NoData")
                }
                
            }
            
            
        }
        
        
        
        if let cellState = cellStates?[indexPath.row] {
            cell.titleLabel.numberOfLines = (cellState == .expanded) ? 0: 5
        }
        
        cell.titleLabel.textColor = UIColor(contrastingBlackOrWhiteColorOn:cell.backgroundColor, isFlat:true)
        cell.descriptionLabel.textColor = UIColor(contrastingBlackOrWhiteColorOn:cell.titleLabel.textColor.darken(byPercentage: 0.4), isFlat:false)
        cell.dateAndTimeLabel.textColor = UIColor(contrastingBlackOrWhiteColorOn:cell.backgroundColor?.lighten(byPercentage: 0.5), isFlat:true)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath) as! NewsTableViewCell
        tableView.beginUpdates()
        cell.titleLabel.numberOfLines = (cell.titleLabel.numberOfLines == 5) ? 0 : 5
        cellStates?[indexPath.row] = (cell.titleLabel.numberOfLines == 5) ? CellState.collapsed : CellState.expanded
        tableView.endUpdates()
    }
}


//MARK: - NEWHTTPMANAGERDELEGATE
extension NewsTableViewController: NewsHTTPManagerDelegate {
    
    func updateTableViewCellComponents(_ withDataDecorator: NewsDataDecorator) {
        DispatchQueue.main.async {
            //            self.arrayOfDatas = withDataDecorator.getSwiftDatas
            let swiftDatas = withDataDecorator.getSwiftDatas
            self.arrayOfDatas = self.makeSortedArrayByType(swiftDatas)
            
            //set searchbar
            self.tableView.tableHeaderView = self.topSearchBar
            
            // got parsed JSON DATA INTO SWIFT OBJECT. NOW RE-LOAD TABLEVIEW
            self.tableView.estimatedRowHeight = 200
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.translatesAutoresizingMaskIntoConstraints = false
            self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
            // initially during loading all cells are collapsed
            self.cellStates = Array(repeating: .collapsed, count: self.arrayOfDatas.count)
            
            //save data in background thread to persistentContainer
            DispatchQueue.global(qos: .background).async {
                self.saveContentsToSQLite()
            }
            
        }
    }
    
    
    func makeSortedArrayByType(_ downloadedArray: [NewsSwiftData]) ->[NewsSwiftData] {
        var textArray = [NewsSwiftData]()
        var imageArray = [NewsSwiftData]()
        var otherArray = [NewsSwiftData]()
        
        for item in downloadedArray {
            if item.type == "image" {
                imageArray.append(item)
            } else if item.type == "other" {
                otherArray.append(item)
            } else {
                textArray.append(item)
            }
        }
        return imageArray + otherArray + textArray
    }
    
    func makeSortedArrayByType(_ downloadedArray: [Content]) ->[Content] {
        var textArray = [Content]()
        var imageArray = [Content]()
        var otherArray = [Content]()
        
        for item in downloadedArray {
            if item.type == "image" {
                imageArray.append(item)
            } else if item.type == "other" {
                otherArray.append(item)
            } else {
                textArray.append(item)
            }
        }
        return imageArray + otherArray + textArray
    }
    
    
}

//MARK: - UISEARCHBARDELEGATE
extension NewsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            DispatchQueue.main.async {
                
                let requestA: NSFetchRequest<Content> = Content.fetchRequest()
                do {
                    self.contentArray = try self.contentContext.fetch(requestA)
                    self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
                } catch  {
                    print(error)
                }
                searchBar.resignFirstResponder()
            }
        } else {
            let requestB: NSFetchRequest<Content> = Content.fetchRequest()
            requestB.predicate = NSPredicate(format: "data CONTAINS %@", searchBar.text!)
            requestB.sortDescriptors = [NSSortDescriptor(key: "type", ascending: true)]
            do {
                self.contentArray = try contentContext.fetch(requestB)
                self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
            } catch  {
                print(error)
            }
        }
        
    }
    
    
}


//MARK: - DATA MANIPULATION
extension NewsTableViewController {
    func saveContentsToSQLite() {
        
        for item in self.arrayOfDatas {
            let newContent = Content(context: contentContext)
            if let safeID = item.id {
                newContent.id = safeID
            }
            if let safeType = item.type {
                newContent.type = safeType
            }
            if let safeDate = item.date {
                newContent.date = safeDate
            }
            if let safeData = item.data {
                newContent.data = safeData
            }
            self.contentArray.append(newContent)
            //save to persistentContainer
            do {
                try contentContext.save()
            } catch {
                print(error)
            }
            
        }
        self.contentArray = self.makeSortedArrayByType(self.contentArray)
    }
    
}


