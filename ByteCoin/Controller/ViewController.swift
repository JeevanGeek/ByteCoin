//
//  ViewController.swift
//  ByteCoin
//
//  Created by Jeevan Chandra Joshi on 12/01/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var bitcoinLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var currencyPicker: UIPickerView!

    var coinService = CoinService()

    override func viewDidLoad() {
        super.viewDidLoad()
        coinService.delegate = self
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }
}

extension ViewController: CoinServiceDelegate {
    func didUpdatePrice(_ coin: CoinModel) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = String(format: "%.2f", coin.price)
            self.currencyLabel.text = coin.currency
        }
    }

    func didFailWithError(_ error: Error) {
        print(error)
    }
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinService.currencies.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinService.currencies[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinService.currencies[row]
        coinService.fetchCoinPrice(selectedCurrency)
    }
}
