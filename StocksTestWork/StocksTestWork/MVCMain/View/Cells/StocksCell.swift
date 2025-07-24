//
//  StocksCell.swift
//  StocksTestWork
//
//  Created by Dmitriy Mikhaylov on 21.07.2025.
//

import UIKit

final class StocksCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var changeLabel: UILabel!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var favoriteButton: UIButton!
    
    // MARK: - Properties
    private var stock: ModelStocks?
    private var isFavorite: Bool = false
    
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
    
        logoImageView.image = nil
        loadingIndicator.stopAnimating()
    }
    
    // MARK: - Configuration
    func configure(with stock: ModelStocks) {
        self.stock = stock
        setupUI()
        configureCell(with: stock)
        loadImage(from: stock.logo)
        updateFavoriteButton(isFavorite: stock.isFav)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        logoImageView.layer.cornerRadius = 12
        logoImageView.clipsToBounds = true
    }
    
    private func configureCell(with stock: ModelStocks) {
        guard let symbol = stock.symbol,
              let name = stock.name,
              let price = stock.price,
              let change = stock.change,
              let changePercent = stock.changePercent else {
            print("Error: Required stock data is nil")
            return
        }
        
        symbolLabel.text = symbol
        nameLabel.text = name
        priceLabel.text = formatPrice(price)
        changeLabel.text = formatChange(change: change, percent: changePercent)
        changeLabel.textColor = change >= 0 ? .systemGreen : .systemRed
    }
    
    private func formatPrice(_ price: Double) -> String {
        return String(format: "$%.02f", price)
    }
    
    private func formatChange(change: Double, percent: Double) -> String {
        if change >= 0 {
            return "+$\(change) (\(percent))"
        } else {
            return "-$\(abs(change)) (\(percent))"
        }
    }
    
    private func loadImage(from urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            print("Error: Invalid logo URL")
            return
        }
        
        setLoading(true)
        
        StocksIconNetworkService.getStockIcons(url: url) { [weak self] imageData in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                guard let self = self else { return }
                
                if let image = UIImage(data: imageData) {
                    self.logoImageView.image = image
                } else {
                    print("Error: Failed to create image from data")
                }
                self.setLoading(false)
            }
        }
    }
    
    private func setLoading(_ isLoading: Bool) {
        isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = !isLoading
    }
    
    private func updateFavoriteButton(isFavorite: Bool) {
        self.isFavorite = isFavorite
        let imageName = isFavorite ? "FavOn" : "FavOff"
        favoriteButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    // MARK: - Actions
    @IBAction private func favoriteButtonTapped(_ sender: UIButton) {
        guard var stock = stock else {
            print("Error: Stock is nil")
            return
        }
        
        isFavorite.toggle()
        stock.isFav = isFavorite
        
        if isFavorite {
            DB.setFavStock(stock)
        } else {
            DB.removeFavStock(stock)
        }
        
        updateFavoriteButton(isFavorite: isFavorite)
    }
}
