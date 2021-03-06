//
//  HomeViewController.swift
//  Pokedex
//
//  Created by Pinto Junior, William James on 10/03/22.
//

import UIKit

class HomeViewController: UIViewController {
    // MARK: - Constrants
    let resuseIdentifier = "PokemonCollectionViewCell"
    let footerReuseIdentifier = "FooterCollectionReusableView"
    let headerReuseIdentifier = "HeaderCollectionReusableView"
    
    // MARK: - Variables
    fileprivate var viewModel: HomeViewModel = {
        return HomeViewModel()
    }()
    fileprivate var pokemonsData: [PokemonModel] = []
    
    // MARK: - Components
    fileprivate let stackBase: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 32
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    fileprivate let labelTitle: UILabel = {
        let label = UILabel()
        label.text = "Pokédex"
        label.font = UIFont(name: "OpenSans-Bold", size: 26)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let labelText: UILabel = {
        let label = UILabel()
        label.text = "Search for a Pokémon by name or using its"
        label.font = UIFont(name: "Roboto-Regular", size: 17)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let labelSubText: UILabel = {
        let label = UILabel()
        label.text = "National Pokédex number"
        label.font = UIFont(name: "Roboto-Regular", size: 17)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let textFieldSearch: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name or number"
        textField.backgroundColor = UIColor(red: 0.91, green: 0.95, blue: 0.95, alpha: 1)
        textField.layer.cornerRadius = 8.0
        textField.setLeftPaddingPoints(15)
        textField.setRightPaddingPoints(15)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    fileprivate let buttonSearch: UIButton  = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.32, green: 0.33, blue: 0.44, alpha: 1)
        button.setImage(UIImage(systemName: "line.3.horizontal.decrease"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8.0
        return button
    }()
    
    fileprivate let pokedexCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    fileprivate func stackHeader() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(labelTitle)
        stack.addArrangedSubview(stackTitle())
        return stack
    }
    
    fileprivate func stackTitle() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(labelText)
        stack.addArrangedSubview(labelSubText)
        return stack
    }

    fileprivate func stackSearch() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(textFieldSearch)
        stack.addArrangedSubview(buttonSearch)
        return stack
    }
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    
    // MARK: - Setup
    fileprivate func setupVC() {
        view.backgroundColor = .white
        viewModel.delegate = self
        
        buildHierarchy()
        buildConstraints()
        setupCollection()
    }
    
    fileprivate func setupCollection() {
        pokedexCollectionView.dataSource = self
        pokedexCollectionView.delegate = self
        
        pokedexCollectionView.register(PokemonCollectionViewCell.self, forCellWithReuseIdentifier: resuseIdentifier)
        pokedexCollectionView.register(FooterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerReuseIdentifier)
    }
    
    // MARK: - Methods
    fileprivate func buildHierarchy() {
        view.addSubview(stackBase)
        stackBase.addArrangedSubview(stackHeader())
        stackBase.addArrangedSubview(stackSearch())
        stackBase.addArrangedSubview(pokedexCollectionView)
    }
    
    fileprivate func buildConstraints() {
        NSLayoutConstraint.activate([
            stackBase.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackBase.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackBase.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackBase.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            textFieldSearch.heightAnchor.constraint(equalToConstant: 50),
            buttonSearch.widthAnchor.constraint(equalToConstant: 50),

        ])
    }
}

// MARK: - extension HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    func collectionDataReload() {
        pokemonsData = viewModel.pokemonsData
        pokedexCollectionView.reloadData()
    }
}

// MARK: - extension FooterCollectionReusableViewDelegate
extension HomeViewController: FooterCollectionReusableViewDelegate {
    func buttonFooterPressed() {
        viewModel.featchNextPokedex()
    }
}

// MARK: - extension CollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let seeVC = SeePokemonViewController()
        seeVC.configCell(pokemonsData[indexPath.row])
        self.navigationController?.pushViewController(seeVC, animated: true)
    }
}

// MARK: - extension CollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonsData.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: resuseIdentifier, for: indexPath) as! PokemonCollectionViewCell
        cell.configCell(pokemon: pokemonsData[indexPath.row])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier, for: indexPath)
            return header
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerReuseIdentifier, for: indexPath) as! FooterCollectionReusableView
            footer.delegate = self
            return footer
        default:
            assert(false, "Unexpected element kind")
        }
    }
}

// MARK: - extension CollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2
        return CGSize(width: width - 10, height: 250)
    }
    
    // Footer
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 90)
    }
}

// MARK: - extension UITextField
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
