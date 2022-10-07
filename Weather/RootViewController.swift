//
//  RootViewController.swift
//  Weather
//
//  Created by Ilxom on 04/10/22.
//

import UIKit

class RootViewController: UIViewController {
    
    var networkManager = NetworkManager()
    
    private let urlString = "https://api.openweathermap.org/data/2.5/weather?q=Bali&apikey=358389cc2e7b7f987ac85f1075b911c6&units=metric"
    
    private let backgroundImage = UIImageView.createImageView(image: UIImage(named: "background"), contentMode: .scaleAspectFill)
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.placeholder = "Search"
        textField.textColor = .black
        return textField
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let temperatureLabel = UILabel.createLabel(text: "20", color: .white, fontSize: 70)
    private let celsiusSignLabel = UILabel.createLabel(text: "°C", color: .white, fontSize: 70)
    private let cityLabel = UILabel.createLabel(text: "Tashkent", color: .white, fontSize: 25)
    
    private let weatherIconImageView = UIImageView.createImageView(image: UIImage(systemName: "cloud.fill"), tintColor: .white)
    
    private lazy var searchStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [searchTextField, searchButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var labelStackView = UIStackView.createStackView(arrangedSubviews: [temperatureLabel, celsiusSignLabel])
    
    private lazy var rootStackView = UIStackView.createStackView(arrangedSubviews: [labelStackView, cityLabel, weatherIconImageView], axis: .vertical, aligment: .center, distribution: .equalSpacing, spacing: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        networkManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateInterfaceWith(weather: currentWeather)
        }
    }
    
    
    private func setupView() {
        view.addSubview(backgroundImage)
        view.addSubview(searchStackView)
        view.addSubview(rootStackView)
        
        searchTextField.delegate = self
        searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        
        let safeG = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: safeG.leadingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: safeG.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: safeG.bottomAnchor),
            
            searchStackView.leadingAnchor.constraint(equalTo: safeG.leadingAnchor),
            searchStackView.topAnchor.constraint(equalTo: safeG.topAnchor, constant: 8),
            searchStackView.trailingAnchor.constraint(equalTo: safeG.trailingAnchor),
            
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 170),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 170),
            
            rootStackView.centerXAnchor.constraint(equalTo: safeG.centerXAnchor),
            rootStackView.topAnchor.constraint(equalTo: searchStackView.bottomAnchor, constant: 60)
        ])
    }
    
    func updateInterfaceWith(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString
            self.weatherIconImageView.image = UIImage(systemName: weather.systemIconNameString)
        }
    }
    
    @objc func searchButtonPressed() {
        guard let city = searchTextField.text else { return }
        networkManager.fetchWeather(cityName: city)
        searchTextField.endEditing(true)
    }
}

extension RootViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type city name"
            return false
        }
    }
}

extension UILabel {
    static func createLabel(text: String, color: UIColor, fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }
}

extension UIImageView {
    static func createImageView(image: UIImage? = nil,
                                contentMode: UIView.ContentMode? = nil,
                                tintColor: UIColor? = nil) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = contentMode ?? .scaleAspectFit
        imageView.tintColor = tintColor ?? .blue
        return imageView
    }
}

extension UIStackView {
    static func createStackView(arrangedSubviews: [UIView],
                                axis: NSLayoutConstraint.Axis? = nil,
                                aligment: UIStackView.Alignment? = nil,
                                distribution: UIStackView.Distribution? = nil,
                                spacing: CGFloat? = nil) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = spacing ?? 8
        stackView.axis = axis ?? .horizontal
        stackView.distribution = distribution ?? .fill
        stackView.alignment = aligment ?? .fill
        return stackView
    }
}
