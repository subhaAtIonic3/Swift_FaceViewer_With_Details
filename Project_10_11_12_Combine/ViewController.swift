//
//  ViewController.swift
//  Project_10_11_12_Combine
//
//  Created by Subhrajyoti Chakraborty on 20/07/20.
//  Copyright © 2020 Subhrajyoti Chakraborty. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var faceArray = [Face]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Face Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        let jsonDecoder = JSONDecoder()
        let userDefaults = UserDefaults.standard
        if let savedData = userDefaults.object(forKey: "faces") as? Data {
            do {
                faceArray = try jsonDecoder.decode([Face].self, from: savedData)
            } catch {
                print("Failed to load faces")
            }
        }
        
    }
    
    @objc func addTapped() {
        let picker = UIImagePickerController()
        
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let face = Face(name: imageName, image: imageName)
        
        faceArray.append(face)
        tableView.reloadData()
        save()
        
        let ac = UIAlertController(title: "Remane face", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let safeText = ac?.textFields?[0].text else { return }
            face.name = safeText
            self?.tableView.reloadData()
            self?.save()
        })
        
        dismiss(animated: true)
        present(ac, animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedDate = try? jsonEncoder.encode(faceArray) {
            let userDefaults = UserDefaults.standard
            userDefaults.set(savedDate, forKey: "faces")
        } else {
            print("Failed to save people.")
        }
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faceArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Face", for: indexPath) as? FaceCell else {
            fatalError("Unable to dequeue FaceCell.")
        }
        
        let face = faceArray[indexPath.row]
        
        cell.name.text = face.name
        
        let imagePath = getDocumentsDirectory().appendingPathComponent(face.image)
        
        cell.imageView?.image = UIImage(contentsOfFile: imagePath.path)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            
            let face = faceArray[indexPath.row]
            let imagePath = getDocumentsDirectory().appendingPathComponent(face.image)
            
            vc.titleString = face.name
            vc.imagePath = imagePath.path
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

