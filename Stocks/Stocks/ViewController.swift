//
//  ViewController.swift
//  Stocks
//
//  Created by Никита Казанцев on 13.12.2020.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
   
    
    @IBOutlet weak var companyNameLabel: UILabel!
    
    @IBOutlet weak var companyPickerView: UIPickerView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var mtdPriceReturnLabel: UILabel!
    
    @IBOutlet weak var netDebtAnnualLabel: UILabel!
    
    @IBOutlet weak var netMarginLabel: UILabel!
    
    private var companies: [String: String] = ["Apple": "AAPL",
                                               "Microsoft": "MSFT",
                                               "Google": "GOOGL",
                                               "Macy's": "M",
                                               "Facebook": "FB"]
    
    private let apiKey: String = "bvatnf748v6ser00knvg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.companyNameLabel.text = "Tinkoff"
        
        self.companyPickerView.dataSource = self
        self.companyPickerView.delegate = self
        
        self.activityIndicator.hidesWhenStopped = true
        
        self.requestQuoteUpdate()
        
        self.loadMoreCompanies()
    }
    
    /// make a request to server to get metric
    /// - Parameter company: which company metrics need to request
    private func requestQuote(for company: String) {
        let url = URL(string: "https://finnhub.io/api/v1/stock/metric?symbol=\(company)&metric=all&token=\(apiKey)")!
        
        let dataTask = URLSession.shared.dataTask(with: url) { data,response,error in
            guard error == nil, (response as? HTTPURLResponse)?.statusCode == 200, let data = data
            else {
                print("Network error")
                DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: "Network error", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            self.parseQuote(data: data)
        }
        
        dataTask.resume()
    }
    
    
    /// function to parse data
    /// - Parameter data: data to parse from
    private func parseQuote(data: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            guard let json = jsonObject as? [String: Any],
                  let companyMetric = json["metric"] as? [String: Any]
            else {
                print("invalid json format")
                DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: "invalid json format", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                }
                return
            }
            print(companyMetric)
            DispatchQueue.main.async {
                self.displayStockInfo(companyInfo: companyMetric)
            }
            
        } catch {
            print("Json parsing error \(error.localizedDescription)")
        }
    }
    
    
    /// Update UI (label text)
    private func requestQuoteUpdate() {
        self.activityIndicator.startAnimating()
        
        self.mtdPriceReturnLabel.text = "-"
        
        self.netDebtAnnualLabel.text = "-"
        
        self.netMarginLabel.text = "-"
        
        self.netMarginLabel.textColor = .black
        
        let selectedRow = self.companyPickerView.selectedRow(inComponent: 0)
        let selectedSymbol = Array(self.companies.values)[selectedRow]
        
        self.companyNameLabel.text =  selectedSymbol
        
        self.requestQuote(for: selectedSymbol)
    }

    
    /// retrive data from dict and update UI
    /// - Parameter companyInfo: some data about company stocks
    private func displayStockInfo(companyInfo: [String: Any]) {
        self.activityIndicator.stopAnimating()
        
        let mtdPrice: Double = companyInfo["monthToDatePriceReturnDaily"] as? Double ??  0.0
        self.mtdPriceReturnLabel.text = String(format: "%.2f", mtdPrice )
        
        let netDebt: Double = companyInfo["netDebtAnnual"] as? Double ??  0.0
        self.netDebtAnnualLabel.text = String(format: "%.2f", netDebt )
        

        let margin: Double = companyInfo["netMarginGrowth5Y"] as? Double ?? 0.0
        
        self.netMarginLabel.text = String(format: "%.2f", margin )
        
        if margin > 0 {
            self.netMarginLabel.textColor = .systemGreen
        }
        else if margin < 0 {
            self.netMarginLabel.textColor = .systemRed
        }
        else {
            self.netMarginLabel.textColor = .black
        }
    }
    
    /// load more copanies from server to fetch their data
    private func loadMoreCompanies() {
        let url = URL(string: "https://finnhub.io/api/v1/stock/symbol?exchange=US&token=\(apiKey)")!
        
        let dataTask = URLSession.shared.dataTask(with: url) { data,response,error in
            guard error == nil, (response as? HTTPURLResponse)?.statusCode == 200, let data = data
            else {
                print("Network error")
                DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: "Network error", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            self.parseCompanies(data: data)
        }
        
        dataTask.resume()
    }
    
    
    /// iterate companies data array and update pciker view with it
    /// - Parameter data: companies retrieved from server data
    private func parseCompanies(data: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            guard let json = jsonObject as? [[String: Any]]
            else {
                print("invalid json format")
                DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: "invalid json format", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            for company in json {
                let symbol = company["symbol"] as? String ?? "-"
                let name = company["description"] as? String ?? "-"
                companies[name] = symbol
            }
            DispatchQueue.main.async {
            self.companyPickerView.reloadAllComponents()
            }
            
            
        } catch {
            print("Json parsing error \(error.localizedDescription)")
        }
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.companies.keys.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(self.companies.keys)[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.requestQuoteUpdate()
    }
    
}

