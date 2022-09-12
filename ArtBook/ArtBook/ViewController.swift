//
//  ViewController.swift
//  ArtBook
//
//  Created by Veysal on 12.09.22.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var nameArray = [String]()
    var idArray = [UUID]()
    var imageArray = [UIImage?]()
    var artistArray = [String]()
    var yearArray = [Int]()
    var selectedImage = UIImage()
    var selectedArtist = ""
    var selectedName = ""
    var selectedYear = 0
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue : "newData"), object: nil)
    }
    
    @objc func getData(){
        nameArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        imageArray.removeAll(keepingCapacity: false)
        artistArray.removeAll(keepingCapacity: false)
        yearArray.removeAll(keepingCapacity: false)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
        fetchRequest.returnsObjectsAsFaults = false
        do{
          let results = try context.fetch(fetchRequest)
            
            for result in results as! [NSManagedObject] {
               
                if let name = result.value(forKey: "name") as? String {
                    nameArray.append(name)
                }
                if let id = result.value(forKey: "id") as? UUID {
                    idArray.append(id)
                }
                if let imageData = result.value(forKey: "image") as? Data {
                    let image = UIImage(data: imageData)
                    imageArray.append(image)
                    
                }
                if let artist = result.value(forKey: "artist") as? String {
                    artistArray.append(artist)
                    print("artist\(artistArray.count)")
                }
                if let year = result.value(forKey: "year") as? Int {
                    yearArray.append(year)
                }
             

                tableView.reloadData()
            }
        } catch {
            print("error")
        }
        
       
        
    }
    
    
    @objc func addButtonClicked() {
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var context = cell.defaultContentConfiguration()
        context.text = nameArray[indexPath.row]
        cell.contentConfiguration = context
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
        selectedName = nameArray[indexPath.row]
        selectedImage = imageArray[indexPath.row]! 
        selectedYear = yearArray[indexPath.row]
        selectedArtist = artistArray[indexPath.row]
        performSegue(withIdentifier: "toSavedDetailsVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSavedDetailsVC" {
        let destinationVC = segue.destination as! SavedDetailsViewController
            destinationVC.artist = selectedArtist
            destinationVC.name = selectedName
            destinationVC.year = selectedYear
           
            destinationVC.imageV = selectedImage
            
        }
    }
}

