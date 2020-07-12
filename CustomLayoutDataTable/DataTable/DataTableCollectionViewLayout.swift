import UIKit

class DataTableCollectionViewLayout: UICollectionViewLayout {

    let settings: DataTableLayoutSettings

    var itemAttributes = [[UICollectionViewLayoutAttributes]]()
    var rowHeights = [CGFloat]()
    var columnWidths = [CGFloat]()
    var contentSize: CGSize = .zero

    weak var dataProvider: TableDataProviding?

    init(settings: DataTableLayoutSettings) {
        self.settings = settings
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var numberOfRows: Int = {
        guard let collectionView = self.collectionView else { return 0 }
        return collectionView.numberOfSections
    }()

    override var collectionViewContentSize: CGSize { contentSize }

    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }

        if collectionView.numberOfSections == 0 {
            return
        }

        if itemAttributes.count != collectionView.numberOfSections {
            generateItemAttributes(collectionView: collectionView)
            return
        }

        /**
            Setting up the sticky header/column
            Loop through all the cells but only action the cells in the header rows and first column
            For the cells in the first column we set the x origin to the x origin of the collection view
            For the cells in the header rows we set the y origin to the y origin of the collection view plus the height of any previous header rows
        **/
        for section in 0..<collectionView.numberOfSections {
            for item in 0..<collectionView.numberOfItems(inSection: section) where section < settings.numberOfStickyRows || item < settings.numberOfStickyColumns {
                guard let attributes = layoutAttributesForItem(at: IndexPath(item: item, section: section)) else { continue }
                if section < settings.numberOfStickyRows {
                    let heightOfPreviousRows: CGFloat = Array(0..<section).reduce(0) { $0 + rowHeights[$1] }
                    attributes.frame.origin.y = collectionView.contentOffset.y + heightOfPreviousRows
                }

                if item < settings.numberOfStickyColumns {
                    let WidthOfPreviousColumns: CGFloat = Array(0..<item).reduce(0) { $0 + columnWidths[$1] }
                    attributes.frame.origin.x = collectionView.contentOffset.x + WidthOfPreviousColumns
                }
            }
        }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        itemAttributes[indexPath.section][indexPath.row]
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        for section in itemAttributes {
            let filteredArray = section.filter { rect.intersects($0.frame) }

            attributes.append(contentsOf: filteredArray)
        }

        return attributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }

}

extension DataTableCollectionViewLayout {
    private func generateItemAttributes(collectionView: UICollectionView) {
        if rowHeights.count != collectionView.numberOfSections {
            calculateItemSizes(collectionView)
        }

        var column = 0
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        var contentWidth: CGFloat = 0

        itemAttributes = []

        for section in 0..<collectionView.numberOfSections {
            var sectionAttributes: [UICollectionViewLayoutAttributes] = []

            for index in 0..<settings.maxNumberOfColumns {
                let itemSize = CGSize(width: columnWidths[index], height: rowHeights[section])
                let indexPath = IndexPath(item: index, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height).integral

                if section < settings.numberOfStickyRows && index < settings.numberOfStickyColumns {
                    // First cell should be on top
                    attributes.zIndex = 1024
                } else if section < settings.numberOfStickyRows || index < settings.numberOfStickyColumns {
                    // First row/column should be above other cells
                    attributes.zIndex = 1023
                }

                if section < settings.numberOfStickyRows {
                    let heightOfPreviousRows: CGFloat = Array(0..<section).reduce(0) { $0 + rowHeights[$1] }
                    attributes.frame.origin.y = collectionView.contentOffset.y + heightOfPreviousRows
                }

                if index < settings.numberOfStickyColumns {
                    let WidthOfPreviousColumns: CGFloat = Array(0..<index).reduce(0) { $0 + columnWidths[$1] }
                    attributes.frame.origin.x = collectionView.contentOffset.x + WidthOfPreviousColumns
                }

                sectionAttributes.append(attributes)

                xOffset += itemSize.width
                column += 1

                if column == settings.maxNumberOfColumns {
                    if xOffset > contentWidth {
                        contentWidth = xOffset
                    }

                    column = 0
                    xOffset = 0
                    yOffset += itemSize.height
                }
            }

            itemAttributes.append(sectionAttributes)
        }

        if let attributes = itemAttributes.last?.last {
            contentSize = CGSize(width: contentWidth, height: attributes.frame.maxY)
        }
    }

    private func calculateItemSizes(_ collectionView: UICollectionView) {
        rowHeights = []
        columnWidths = Array(repeating: 0, count: settings.maxNumberOfColumns)

        for rowIndex in 0..<collectionView.numberOfSections {
            var maxHeight: CGFloat = 0

            for columnIndex in 0..<settings.maxNumberOfColumns {
                guard let text = dataProvider?.textForCell(at: IndexPath(row: columnIndex, section: rowIndex)),
                    let size = text.sizeOfString(constrainedToWidth: Double(settings.maxCellWidth)) else { continue }

                let heightWithPadding = size.height + settings.cellPadding.top + settings.cellPadding.bottom
                maxHeight = max(heightWithPadding, maxHeight)

                let widthWithPadding = size.width + settings.cellPadding.left + settings.cellPadding.right
                columnWidths[columnIndex] = max(widthWithPadding, columnWidths[columnIndex])
            }
            rowHeights.append(maxHeight)

        }
    }
}

extension NSAttributedString {
    func sizeOfString(constrainedToWidth width: Double) -> CGSize? {
        guard let font = self.attribute(.font, at: 0, effectiveRange: nil) as? UIFont else { return CGSize(width: 0, height: 0)}
        return NSString(string: self.string).boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude),
                                                     options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                     attributes: [NSAttributedString.Key.font: font],
                                                     context: nil).size
    }
}
