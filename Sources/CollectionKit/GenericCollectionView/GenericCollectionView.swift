//
//  File.swift
//  
//
//  Created by Paul on 21/05/2023.
//

import UIKit
import Resource
import Repository

open class GenericCollectionView<Cell: CollectionCell<ItemModel>,
ItemModel: CodableResource, CellVMType: CellViewModel>: UICollectionView {
        
    //MARK: - Initializer
        
    @available(*,unavailable,message:"Don't use init(coder:),override init(frame:)")
    required public init?(coder: NSCoder) { fatalError("init(coder: ) was not implemented") }

    //MARK: - Properties
    
    public let repository: RepositoryProtocol
    public var diffableDataSource:  UICollectionViewDiffableDataSource<String,String>? {
        return genericDataSource.getDiffableDataSource()
    }
    public let genericDelegate: CollectionDelegateProtocol
    public var genericDataSource: GenericCollectionDataSourceProtocol!
    public var requiredCellDelegate: GenericCellDelegate!
    public var requiredLayout: RequiredLayoutProtocol!
    
    private lazy var dataSourceBuilder = GenericDataSourceBuilder<Cell,ItemModel,CellVMType>( repository,genericDelegate)
        
    //MARK: - Required Initializer
    public init(_ repository: RepositoryProtocol,
                _ genericDelegate: CollectionDelegateProtocol) {
                
        self.repository = repository
        self.genericDelegate = genericDelegate
                        
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        
        self.genericDataSource = dataSourceBuilder.makeGenericDataSource()
        configureCollectionView()
        setupDataSource()
    }
    
    //MARK: - Public Ovveridable Methods

    open func configure() { }
    
    open func setupDataSource() {   }
    
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        configure()
        setupLayout()
    }
    
    //MARK: - Private Methods
    
    private func configureCollectionView() {
        setupCollectionView()
    }
    
    private func setupLayout() {
        guard let layout = requiredLayout.getLayout() else { return }
            self.collectionViewLayout = layout
    }

    private func setupCollectionView() {
        
        self.register(Cell.self, forCellWithReuseIdentifier: Cell.cellReuseIdentifier)
  
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        
        genericDataSource.collectionView = self
        self.delegate = dataSourceBuilder.getDelegate()
        
        self.backgroundColor = .clear
        self.delaysContentTouches = false
    }
}


//MARK: - Required Layout

public protocol RequiredLayoutProtocol {
    func makeLayout() -> GenericCollectionLayout.CellLayout
    func getLayout() -> UICollectionViewLayout?
}

public extension RequiredLayoutProtocol {
    
    func getLayout() -> UICollectionViewLayout? {
        let genericLayout = GenericCollectionLayout()
        guard let layout = genericLayout.setupLayout(makeLayout()) else {return nil}
        return layout
    }
}

//MARK: - Required DataSource

public protocol RequiredDataSourceProtocol: AnyObject {
    func getGenericDataSource() -> GenericCollectionDataSourceProtocol
    func getDataSource(_ collectionView: UICollectionView) -> UICollectionViewDataSource!
    func configureDiffableDataSource(using genericDataSource: GenericCollectionDataSourceProtocol ,_ items: [String])
}

public extension RequiredDataSourceProtocol {
    
    func getDataSource(_ collectionView: UICollectionView) -> UICollectionViewDataSource! {
        
        let genericDataSource = getGenericDataSource()
        genericDataSource.collectionView = collectionView
        return genericDataSource.getDiffableDataSource()
    }
    
    func configureDiffableDataSource(using genericDataSource: GenericCollectionDataSourceProtocol ,_ items: [String]) {
        
          genericDataSource.configureDiffableDataSource(items)
    }
}
