//
//  CustomTableViewCell.swift
//  GBM-Challenge
//
//  Created by Joaquín González Cervantes on 08/05/22.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    static let identifier = "CustomTableViewCell"
    
    let viewModelHelper = ViewModelHelper()
        
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let percentageChangeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let volumeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let changeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        
        stackView.backgroundColor = .systemBackground
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with ipc: IPC) {
        dateLabel.text = viewModelHelper.getFormattedDate(isoDate: ipc.date)
        priceLabel.text = "Price: \(ipc.price)"
        percentageChangeLabel.text = "Percentage Change: \(ipc.percentageChange)"
        volumeLabel.text = "Volume: \(ipc.volume)"
        changeLabel.text = "Change: \(ipc.change)"
    }
    
    private func setup() {
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(percentageChangeLabel)
        stackView.addArrangedSubview(volumeLabel)
        stackView.addArrangedSubview(changeLabel)
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1)
        ])
    }
}
