//
//  File.swift
//  
//
//  Created by Paul on 22/05/2023.
//

import UIKit

open class CollectionCell<DataType>: UICollectionViewCell, CellConfiguration, GenericComponent {
   
    typealias ItemModel = DataType
    
    public enum Highlight { case enabled, disabled }
    
    //MARK: - Lifecycle
    
    weak open var delegate: GenericCellDelegate?
        
    @available(*,unavailable,message:"Don't use init(coder:),override init(frame:) instead ")
    public required init?(coder: NSCoder) { super.init(coder: coder) }

    public override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configure()
        constrain()
    }
    
    open override var isHighlighted: Bool {
        
        didSet {
            
            if enableHighlight == .enabled {
                
                if isHighlighted {
                    backgroundColor = UIColor.systemGray6.withAlphaComponent(0.3)
                } else {
                    backgroundColor = .white
                }
            }
        }
    }
    
    //MARK: - Public Interface
    
    open private(set) var enableHighlight: Highlight = .disabled
    
    open func configure() { fatalError() }

    open func constrain() { fatalError() }

    open func configureCell(with item: DataType) { fatalError()   }
    
    open func configureTappedCell(status: Bool) { fatalError()    }
    
    open func shouldHighlightCell(selection: SelectionState? = nil,status: Bool) {   fatalError()   }
    
    
    open func setupCell(with item: DataType) {
        fatalError("This method needs to e overriden inside subclass")
    }
    
    open func configureConstrainCell() {
        fatalError("This method needs to e overriden inside subclass")
    }
    
    open func isSelected(resource: DataType) {
        fatalError("This method needs to e overriden inside subclass")
    }
    
    open func resetCell(status: Bool) {
        fatalError()
    }
    
    open func restoreCell(status: Bool) {
        fatalError()
    }
    
    open func shouldHighlightCell(status: Bool) {
        if status { print("Highlight: \(Self.self)") }
       // fatalError()
    }
}


public protocol GenericCell: CustomStringConvertible {
    var delegate: GenericCellDelegate? {get set }
}

public protocol CellConfiguration {
    
    associatedtype T

    var delegate: GenericCellDelegate? { get set}
    func setupCell(with: T)
    func configureConstrainCell()
    func isSelected(resource: T)
    func configureTappedCell(status: Bool)
    func resetCell(status: Bool)
    func restoreCell(status: Bool)
    func shouldHighlightCell(status: Bool)
}

extension CellConfiguration {
    var delegate: GenericCellDelegate? {
        get { fatalError() }
        set { fatalError() }
    }
}


public protocol GenericCellDelegate: AnyObject {
    
    func genericCell(_ cell: UICollectionViewCell, didTapOn button: UIView)
}

protocol GenericCollectionProtocol: GenericCellDelegate { }

protocol GenericCellProtocol {
    var delegate: GenericCellDelegate? { get set }
}


extension GenericCell {
    public var delegate: GenericCellDelegate? {
        get { fatalError() }
        set { fatalError() }
    }
}



public enum SelectionState {
    case initial, selected, highlighted, emptyCircle
}


public protocol GenericComponent: CustomStringConvertible {
    /* empty protocol */
}
public extension UICollectionViewCell {
    
    static var cellReuseIdentifier: String { String(describing: Self.self) }
}

//MARK: Default Methods for GenericCellVM

extension UICollectionView: GenericComponent { }

extension CollectionCell: GenericCell {}
