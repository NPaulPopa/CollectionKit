//
//  File.swift
//  
//
//  Created by Paul on 30/05/2023.
//

import Foundation

import UIKit
import Resource
import Repository

open class GenericCollectionViewController<Cell: CollectionCell<ItemModel>,
ItemModel: CodableResource, CellVMType: CellViewModel>: UICollectionViewController {
        
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
                            
        super.init(collectionViewLayout: UICollectionViewLayout())
        
        self.genericDataSource = dataSourceBuilder.makeGenericDataSource()
        configureCollectionView()
        setupDataSource()
    }
    
    //MARK: - Public Ovveridable Methods

    open func configure() { }
    
    open func setupDataSource() {   }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupLayout()
    }
    
    //MARK: - Private Methods
    
    private func configureCollectionView() {
        setupCollectionView()
    }
    
    private func setupLayout() {
        
        guard let requiredLayout = requiredLayout,
                let layout = requiredLayout.getLayout() else { return }
        self.collectionView.collectionViewLayout = layout
    }

    private func setupCollectionView() {
        
        self.collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.cellReuseIdentifier)
  
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        
        genericDataSource.collectionView = self.collectionView
        self.collectionView.delegate = dataSourceBuilder.getDelegate()
        
        self.collectionView.backgroundColor = .clear
        self.collectionView.delaysContentTouches = false
    }
}
