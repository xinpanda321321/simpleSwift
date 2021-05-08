//
//  ViewController.swift
//  JsonImportExport
//
//  Created by sinpanda on 5/7/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData1()
        AppManager.shared.flag = 0
        AppManager.shared.indexP = -1
    }
    
    func loadData1() {
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            let fileUrl = documentsDirectoryUrl.appendingPathComponent("Persons.json")

            // Read data from .json file and transform data into an array
            do {
                let data = try Data(contentsOf: fileUrl, options: [])
                guard let personArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else { return }
                AppManager.shared.tableData = personArray
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print(error)
            }
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        AppManager.shared.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as! tableViewCell
        
        let tempData = AppManager.shared.tableData[indexPath.row]["date"] as! [String]
        cell.date1.text = tempData[0]
        cell.date2.text = tempData[1]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 117
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppManager.shared.flag = 1
        AppManager.shared.indexP = indexPath.row
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let balanceViewController = storyBoard.instantiateViewController(withIdentifier: "balance") as! DetailsViewController
        self.navigationController?.pushViewController(balanceViewController, animated: true)
    }
}
