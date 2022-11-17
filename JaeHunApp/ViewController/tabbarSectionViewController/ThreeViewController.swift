//
//  ThreeViewController.swift
//  JaeHunApp
//
//  Created by 이재훈 on 2022/11/16.
//

import UIKit

class ThreeViewController: UITableViewController {
    var beerList = [Beer]()
    var dataTasks = [URLSessionTask]()
    var currentPage = 1

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Drink"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupTableView()
        fetchBeer(of: currentPage)
        
    }
}

extension ThreeViewController {
    private func setupTableView(){
        view.backgroundColor = .systemBackground
        tableView.prefetchDataSource = self
        tableView.register(BeerListCell.self, forCellReuseIdentifier: "BeerListCell")
        tableView.rowHeight = 150
        tableView.separatorStyle = .none
    }
    
    private func fetchBeer(of page: Int) {
        guard let url = URL(string: "https://api.punkapi.com/v2/beers?page=\(page)"),
              dataTasks.firstIndex(where: {$0.originalRequest?.url == url}) == nil else {
            return // 이미 fetch이 됐다면 하지 않음
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
            // URLSession HTTP/HTTPS 통해 콘텐츠를 주고 받는 API를 제공하는 클래스
            // Session은 재사용 X
            // HTTP의 각종 메서드를 이용해 서버로부터 응답 데이터를 받아서 Data 객체를 가져오는 작업을 수행
            // shared 변수를 통해 싱글톤 객체 생성 -> URLSession 함수를 사용 가능
            // 단 delegate 없고, 커스텀마이징된 configuration 없음
            guard error == nil,
                  let self = self,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let beers = try? JSONDecoder().decode([Beer].self, from: data) else {
                print("ERROR: URLSession data task error \(error?.localizedDescription ?? "")")
                return
            }
            switch response.statusCode {
            case (200...299):
                self.beerList += beers
                self.currentPage += 1
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case (400...499):
                print("""
                    ERROR: Client ERROR \(response.statusCode)
                    Response: \(response)
                """)
            case (500...599):
                print("""
                    ERROR: Server ERROR \(response.statusCode)
                    Response: \(response)
                """)
            default:
                print("""
                    ERROR: \(response.statusCode)
                    Response: \(response)
                """)
            }
        }
        dataTask.resume()
        dataTasks.append(dataTask)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BeerListCell", for: indexPath) as? BeerListCell else { return UITableViewCell() }
        let beer = beerList[indexPath.row]
        cell.configure(with: beer)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBeer = beerList[indexPath.row]
        let vc = BeerDetailViewController()
        vc.beer = selectedBeer
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ThreeViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard currentPage != 1 else {return} // 1이번 prefetching할 필요 없음
        
        indexPaths.forEach {
            if ($0.row + 1)/25 + 1 == currentPage { // 25개의 아이템 이상이면 fetchBeer 시작
                self.fetchBeer(of: currentPage)
            }
        }
    }
    
    
    
    
}
