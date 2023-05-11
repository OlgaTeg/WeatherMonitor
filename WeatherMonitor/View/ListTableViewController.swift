//
//  ListTableViewController.swift
//  WeatherMonitor
//
//  Created by Olga Tegza on 21.04.2023.
//

import UIKit


class ListTableViewController: UITableViewController {
    
    let emptyCity = Weather()
    
    var citiesArray = [Weather]()
    var filteredCitiesArray = [Weather]()
    
    var namesOfCitiesArray = ["Москва", "Санкт-Петербург", "Пенза", "Уфа", "Новосибирск", "Челябинск", "Омск", "Екатеринбург", "Томск", "Сочи"]
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    var isFiltered: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if citiesArray.isEmpty {
            citiesArray = Array(repeating: emptyCity, count: namesOfCitiesArray.count)
        }
        addCities()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    @IBAction func addCityButtonPressed(_ sender: Any) {
        addCityAlert(name: "Город", placeholder: "Введите название города") { city in
            self.namesOfCitiesArray.append(city)
            self.citiesArray.append(self.emptyCity)
            self.addCities()
        }
    }
    
    func addCities() {
        getCityweather(citiesArray: self.namesOfCitiesArray) { (index, weather) in
            self.citiesArray[index] = weather
            self.citiesArray[index].name = self.namesOfCitiesArray[index]
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        isFiltered == true ? filteredCitiesArray.count : citiesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListCell
        var weather = Weather()
        if isFiltered {
            weather = filteredCitiesArray[indexPath.row]
        } else {
            weather = citiesArray[indexPath.row]
        }
        cell.configure(weather: weather)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, completionHandler in
            let editingRow = self.namesOfCitiesArray[indexPath.row]
            if let index = self.namesOfCitiesArray.firstIndex(of: editingRow) {
                
                if self.isFiltered {
                    self.filteredCitiesArray.remove(at: index)
                } else {
                    self.citiesArray.remove(at: index)
                }
            }
            tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            if isFiltered {
                let filter = filteredCitiesArray[indexPath.row]
                let dstVC = segue.destination as! DetailViewController
                dstVC.weatherModel = filter
            } else {
                let cityWeather = citiesArray[indexPath.row]
                let dstVC = segue.destination as! DetailViewController
                dstVC.weatherModel = cityWeather
            }
        }
    }
}


extension ListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    private func filterContentForSearchText(_ searchText: String) {
        filteredCitiesArray = citiesArray.filter {
            $0.name.contains(searchText)
        }
        tableView.reloadData()
    }
}
