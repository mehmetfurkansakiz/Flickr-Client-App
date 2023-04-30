//
//  RecentPhotosTableViewController .swift
//  Flickr Client App
//
//  Created by furkan sakız on 25.04.2023.
//

import UIKit

class RecentPhotosTableViewController: UITableViewController, UISearchResultsUpdating {

    private var response: PhotosResponse? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        fetchRecentPhotos()
    }
    
    // MARK: - Fetch Photos
    private func fetchRecentPhotos() {
        guard let url = URL(string : "https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=c5f4b67bc41dfc9ef1d47da1dd791b5b&format=json&nojsoncallback=1&extras=description,owner_name,icon_server,url_n,url_z") else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                debugPrint(error)
                return
            }
            if let data = data, let response = try? JSONDecoder().decode(PhotosResponse.self, from: data) {
                self.response = response
            }
        }.resume()
    }
    // MARK: - Fetch Search
    private func searchPhotos(with text: String) {
        guard let url = URL(string : "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=c5f4b67bc41dfc9ef1d47da1dd791b5b&text=flower&format=json&nojsoncallback=1&extras=description,owner_name,icon_server,url_n,url_z") else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                debugPrint(error)
                return
            }
            if let data = data, let response = try? JSONDecoder().decode(PhotosResponse.self, from: data) {
                self.response = response
            }
        }.resume()
    }
    // MARK: - SearchBar
    private func setupSearchController() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = search
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response?.photos?.photo?.count ?? .zero
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let photo = response?.photos?.photo?[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PhotoTableViewCell
        cell.ownerImageView.backgroundColor = .darkGray
        cell.ownerNameLabel.text = photo?.ownername
        
        if let urlString = photo?.urlN,let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    debugPrint(error)
                    return
                }
                if let data = data {
                    DispatchQueue.main.async {
                        cell.photoImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        cell.titleLabel.text = photo?.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailSeue", sender: nil)
    }
    
    // MARK: - Navigation

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        if let viewController = segue.destination as? PhotoDetailViewController {
//            // TODO: send selected photo to detail screen
//        }
//    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        if text.count > 2 {
            searchPhotos(with: text)
        }
    }
}

