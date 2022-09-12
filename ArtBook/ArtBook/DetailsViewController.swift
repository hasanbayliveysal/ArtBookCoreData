//
//  DetailsViewController.swift
//  ArtBook
//
//  Created by Veysal on 12.09.22.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var artistText: UITextField!
    @IBOutlet weak var yearText: UITextField!

    var chosenPainting = ""
    var chosenPaintingId : UUID?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.isEnabled = false
        if chosenPainting != "" {
            button.isHidden = true
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appdelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
            fetchRequest.returnsObjectsAsFaults = false
            let stringUUID = chosenPaintingId?.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", stringUUID!)
            
            do{
               
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let name = result.value(forKey: "name") as? String {
                            nameText.text = name
                        }
                        if let image = result.value(forKey: "image") as? Data {
                            self.image.image = UIImage(data: image)
                        }
                        if let artist = result.value(forKey: "artist") as? String {
                            artistText.text = artist
                        }
                        if let year = result.value(forKey: "year") as? Int {
                            yearText.text = String(year)
                        }
                        
                    }
                }
                
                
            }catch {
                print("error")
            }
            
            
        }else {
            
        }
    
        image.isUserInteractionEnabled = true
        
        // MARK - Recognizers
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTappedAnywhere))
        view.addGestureRecognizer(gestureRecognizer)
        
        let gestureRecognizerForImage = UITapGestureRecognizer(target: self, action: #selector(onTappedImage))
        image.addGestureRecognizer(gestureRecognizerForImage)
        
    }
  
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPainting = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context)
        newPainting.setValue(artistText.text!, forKey: "artist")
        newPainting.setValue(nameText.text!, forKey: "name")
        if let year = Int(yearText.text!){
            newPainting.setValue(year, forKey: "year")
        }
        newPainting.setValue(UUID(), forKey: "id")
        let data = image.image?.jpegData(compressionQuality: 0.5)
        newPainting.setValue(data, forKey: "image")
        
        do {
           try context.save()
           print("sucses")
        } catch {
            print("Error")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue : "newData"), object: nil)
        
        self.navigationController?.popViewController(animated: true)
        
       
      
       
    }
    
 
    
    
    @objc func onTappedAnywhere() {
        
        view.endEditing(true)
        
    }
    
    @objc func onTappedImage() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        button.isEnabled = true
    }
    
    
}
