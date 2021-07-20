//
//  ViewController.swift
//  Project7
//
//  Created by user on 20/07/21.
//

import UIKit

class ViewController: UITableViewController {
    
    //MARK: - Attributes
    
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
// Challenge 1 - Add a Credits button to the top-right corner using UIBarButtonItem.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        
        let filter = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        
        let reset = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(resetTapped))
        
        navigationItem.leftBarButtonItems = [filter, reset]
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        
        if let url = URL(string: urlString) {

            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
            
            showError()
        }
        
    }
    
    //MARK: - Methods
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
// Challenge 1 - Add a Credits button to the top-right corner using UIBarButtonItem.
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "Data from: We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
//Challenge 2 - Let users filter the petitions they see.
    
    @objc func searchTapped() {
        let ac = UIAlertController(title: "Search keyword", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak ac, self] _ in
            guard let keyword = ac?.textFields?[0].text else { return }
            self.filter(answer: keyword)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
        
    }
    
    @objc func resetTapped() {
        filteredPetitions.removeAll()
        tableView.reloadData()
    }
    
    func filter(answer: String) {
        
        for word in petitions {
            if word.title.lowercased().contains(answer.lowercased()){
                    filteredPetitions.append(word)
            }
        }
        
        if filteredPetitions.isEmpty {
            let ac = UIAlertController(title: "Error", message: "No match found!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
        }
        
        tableView.reloadData()
    }
    
    //MARK: - TablewView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.isEmpty ? petitions.count : filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        if filteredPetitions.isEmpty {
            cell.textLabel?.text = petitions[indexPath.row].title
            cell.detailTextLabel?.text = petitions[indexPath.row].body
        } else {
            cell.textLabel?.text = filteredPetitions[indexPath.row].title
            cell.detailTextLabel?.text = filteredPetitions[indexPath.row].body
        }
        
//        cell.textLabel?.text = petition.title
//        cell.detailTextLabel?.text = petition.body

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

