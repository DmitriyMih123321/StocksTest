//
//  StocksViewController.swift
//  StocksTestWork
//
//  Created by Dmitriy Mikhaylov on 21.07.2025.
//

import UIKit

final class StocksViewController: UIViewController {
    
    // MARK: - UI Properties
    @IBOutlet private weak var searchView: UIView!
    @IBOutlet private weak var searchIconButton: UIButton!
    @IBOutlet private weak var searchField: UITextField!
    @IBOutlet private weak var clearSearchButton: UIButton!
    @IBOutlet private weak var segmentView: UIView!
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    @IBOutlet private weak var collectionContainerView: UIView!
    @IBOutlet private weak var stocksCollectionView: UICollectionView!
    @IBOutlet private weak var searchHelpView: UIView!
    @IBOutlet private weak var popularCollectionView: UICollectionView!
    @IBOutlet private weak var searchHistoryCollectionView: UICollectionView!
    
    // MARK: - Data Properties
    private var stocks = [ModelStocks]()
    private var favoriteStocks = [ModelStocks]()
    private var filteredStocks = [ModelStocks]()
    private var searchHistory = [String]()
    private let popularStocks = ["Apple", "Amazon", "Google", "Tesla", "Microsoft",
                               "First Solar", "Alibaba", "Facebook", "Mastercard"]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadStocks()
    }
    
    // MARK: - Configuration
    private func configureUI() {
        setupSearchView()
        setupSegmentControl()
        setupCollectionViews()
        setupKeyboardObservers()
    }
    
    private func setupSearchView() {
        searchView.layer.cornerRadius = searchView.frame.height / 2
        searchView.layer.borderColor = UIColor.black.cgColor
        searchView.layer.borderWidth = 1.0
        
        searchField.attributedPlaceholder = NSAttributedString(
            string: "Find company or ticker",
            attributes: [
                .foregroundColor: UIColor.black,
                .font: UIFont(name: "Montserrat-SemiBold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .semibold)
                
            ]
        )
        clearSearchButton.isHidden = true
        
        searchField.delegate = self
        searchField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        searchField.addTarget(self, action: #selector(searchTextChanged), for: .editingDidBegin)
    }
    
    private func setupSegmentControl() {
        segmentControl.backgroundColor = .clear
        segmentControl.tintColor = .clear
        let image = imageWithColor(color: .white)
        segmentControl.setBackgroundImage(image, for: .normal, barMetrics: .default)
        segmentControl.setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont(name: "Montserrat-Bold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont(name: "Montserrat-Bold", size: 28) ?? UIFont.systemFont(ofSize: 28, weight: .bold)
        ]
        
        segmentControl.setTitleTextAttributes(normalAttributes, for: .normal)
        segmentControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        segmentControl.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
    }
    private func imageWithColor(color: UIColor) -> UIImage {
             let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
             UIGraphicsBeginImageContext(rect.size)
             let context = UIGraphicsGetCurrentContext()
             context!.setFillColor(color.cgColor);
             context!.fill(rect);
             let image = UIGraphicsGetImageFromCurrentImageContext();
             UIGraphicsEndImageContext();
             return image!
         }
    
    private func setupCollectionViews() {
         
        [popularCollectionView, searchHistoryCollectionView].forEach {
            $0?.collectionViewLayout = createCompositionalLayout()
            $0?.backgroundColor = .white
        }
        
        stocksCollectionView.backgroundColor = .white
        stocksCollectionView.delegate = self
        stocksCollectionView.dataSource = self
        searchHistoryCollectionView.dataSource = self
        searchHistoryCollectionView.delegate = self
        popularCollectionView.dataSource = self
        popularCollectionView.delegate = self
        toggleViewsVisibility(showSearchHelp: false)
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .estimated(60),
                heightDimension: .absolute(40)
                )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(50))
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item])
            
            group.interItemSpacing = .fixed(5)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .zero
            section.interGroupSpacing = 5
            
            return section
        }
    }
    
  
    
    // MARK: - Data Loading
    private func loadStocks() {
        StocksNetworkService.getStocks { [weak self] result in
            let checkedStocks = GetCheckedFavStocks.checkFavourite(stocksAll: result.stocks)
            self?.stocks = checkedStocks.changed
            self?.favoriteStocks = checkedStocks.favs
            self?.stocksCollectionView.reloadData()
           
        }
    }
    
    // MARK: - Actions
    @IBAction private func clearSearch(_ sender: Any) {
        searchField.text = ""
        clearSearchButton.isHidden = true
        toggleViewsVisibility(showSearchHelp: true)
        stocksCollectionView.reloadData()
    }
    
    @IBAction private func searchButtonTapped(_ sender: Any) {
        searchField.text = ""
        clearSearchButton.isHidden = true
        searchField.resignFirstResponder()
        toggleViewsVisibility(showSearchHelp: false)
        searchIconButton.setImage(UIImage(named: "Search"), for: .normal)
        stocksCollectionView.reloadData()
    }
    
    @objc private func segmentValueChanged(_ sender: UISegmentedControl) {
        updateStocksDisplay()
    }
    
    @objc private func searchTextChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if text.isEmpty {
            toggleViewsVisibility(showSearchHelp: true)
            popularCollectionView.reloadData()
            searchHistoryCollectionView.reloadData()
        } else {
            toggleViewsVisibility(showSearchHelp: false)
            clearSearchButton.isHidden = false
            stocksCollectionView.reloadData()
        }
    }
    
    // MARK: - Helper Methods
    private func toggleViewsVisibility(showSearchHelp: Bool) {
        searchHelpView.isHidden = !showSearchHelp
        segmentView.isHidden = showSearchHelp
        collectionContainerView.isHidden = showSearchHelp
    }
    
    private func updateStocksDisplay() {
        if segmentControl.selectedSegmentIndex == 1 {
            favoriteStocks = DB.getFavStocks()
        } else {
            stocks = GetCheckedFavStocks.checkFavourite(stocksAll: stocks).changed
        }
        stocksCollectionView.reloadData()
    }
    
    private func filterStocks(with text: String) -> [ModelStocks] {
        guard !text.isEmpty else {
            return segmentControl.selectedSegmentIndex == 0 ? stocks : favoriteStocks
        }
        
        let source = segmentControl.selectedSegmentIndex == 0 ? stocks : favoriteStocks
        return source.filter { $0.name?.lowercased().contains(text.lowercased()) ?? false }
    }
}

// MARK: - UICollectionView DataSource
extension StocksViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case popularCollectionView:
            return popularStocks.count
        case searchHistoryCollectionView:
            return searchHistory.count
        case stocksCollectionView:
            filteredStocks = filterStocks(with: searchField.text?.lowercased() ?? "")
            return filteredStocks.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case popularCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularCell", for: indexPath) as! PopularSearchCell
            
            cell.configure(with: popularStocks[indexPath.item])
            return cell
            
        case searchHistoryCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "youSearchCell", for: indexPath) as! YouSearchCell
            cell.configure(with: searchHistory[indexPath.item])
            return cell
            
        case stocksCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stocksCell", for: indexPath) as! StocksCell
            
            let stock = filteredStocks[indexPath.item]
            cell.configure(with: stock)
            cell.layer.cornerRadius = 16
            if indexPath.item % 2 != 0 {
                cell.contentView.backgroundColor = UIColor(red: 240/255, green: 244/255, blue: 247/255, alpha: 1)
            } else {
                cell.contentView.backgroundColor = .white
            }
            
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionView Delegate
extension StocksViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case popularCollectionView:
            searchField.insertText(popularStocks[indexPath.item])
            toggleViewsVisibility(showSearchHelp: false)
            clearSearchButton.isHidden = false
        case searchHistoryCollectionView:
            searchField.insertText(searchHistory[indexPath.item])
            toggleViewsVisibility(showSearchHelp: false)
            clearSearchButton.isHidden = false
        default:
            break
        }
    }
}

// MARK: - UITextField Delegate
extension StocksViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            stocksCollectionView.reloadData()
            return true
        }
        
        searchHistory.removeAll { $0 == text }
        searchHistory.append(text)
        searchHistoryCollectionView.reloadData()
        clearSearchButton.isHidden = true
        textField.resignFirstResponder()
        toggleViewsVisibility(showSearchHelp: false)
        
        return true
    }
}

// MARK: - Keyboard Handling
extension StocksViewController {
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc private func keyboardWillShow() {
        clearSearchButton.isHidden = false
        searchIconButton.setImage(UIImage(named: "Back"), for: .normal)
    }
    
    @objc private func keyboardWillHide() {
        view.endEditing(true)
        toggleViewsVisibility(showSearchHelp: searchField.text?.isEmpty ?? true)
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
}

// MARK: - Model Extensions
extension ModelStocks {
    var formattedPrice: String {
        guard let price = price else { return "N/A" }
        return String(format: "$%.02f", price)
    }
    
    var formattedChange: (text: String, color: UIColor) {
        guard let change = change, let percent = changePercent else {
            return ("N/A", .gray)
        }
        
        if change >= 0 {
            return ("+$\(change) (+\(percent))", .systemGreen)
        } else {
            return ("-$\(abs(change)) (\(percent))", .systemRed)
        }
    }
}
