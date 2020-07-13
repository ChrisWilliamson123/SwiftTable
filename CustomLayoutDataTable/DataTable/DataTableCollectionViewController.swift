import UIKit

private let reuseIdentifier = "DataTableCollectionViewCell"



class DataTableCollectionViewController: UICollectionViewController {

    typealias DataTableRow = (type: DataTableRowType, columns: [String])

    let data: [DataTableRow] = [
        (.header, ["Lampard's record at Derby"]),
        (.header, ["Competition", "Games", "Won", "Drawn", "Lost", "Goals for", "Goals against", "Win %"]),
        (.regular, ["Championship (inc. play-offs)", "49", "21", "14", "14", "74", "59", "42.9%"]),
        (.regular, ["League Cup", "4", "2", "1", "1", "10", "5", "50%"]),
        (.regular, ["FA Cup", "4", "1", "2", "1", "6", "6", "25%"]),
        (.regular, ["League Cup", "4", "2", "1", "1", "10", "5", "50%"]),
        (.regular, ["FA Cup", "4", "1", "2", "1", "6", "6", "25%"]),
        (.regular, ["League Cup", "4", "2", "1", "1", "10", "5", "50%"]),
        (.regular, ["FA Cup", "4", "1", "2", "1", "6", "6", "25%"]),
        (.regular, ["League Cup", "4", "2", "1", "1", "10", "5", "50%"]),
        (.regular, ["FA Cup", "4", "1", "2", "1", "6", "6", "25%"]),
        (.regular, ["League Cup", "4", "2", "1", "1", "10", "5", "50%"]),
        (.regular, ["FA Cup", "4", "1", "2", "1", "6", "6", "25%"]),
        (.regular, ["League Cup", "4", "2", "1", "1", "10", "5", "50%"]),
        (.regular, ["FA Cup", "4", "1", "2", "1", "6", "6", "25%"]),
        (.regular, ["League Cup", "4", "2", "1", "1", "10", "5", "50%"]),
        (.regular, ["FA Cup", "4", "1", "2", "1", "6", "6", "25%"]),
        (.regular, ["League Cup", "4", "2", "1", "1", "10", "5", "50%"]),
        (.regular, ["FA Cup", "4", "1", "2", "1", "6", "6", "25%"]),
        (.regular, ["League Cup", "4", "2", "1", "1", "10", "5", "50%"]),
        (.regular, ["FA Cup", "4", "1", "2", "1", "6", "6", "25%"]),
        (.regular, ["League Cup", "4", "2", "1", "1", "10", "5", "50%"]),
        (.regular, ["FA Cup", "4", "1", "2", "1", "6", "6", "25%"]),
        (.regular, ["League Cup", "4", "2", "1", "1", "10", "5", "50%"]),
        (.regular, ["FA Cup", "4", "1", "2", "1", "6", "6", "25%"]),
        (.regular, ["League Cup", "4", "2", "1", "1", "10", "5", "50%"]),
        (.regular, ["FA Cup", "4", "1", "2", "1", "6", "6", "25%"]),
        (.regular, ["League Cup", "4", "2", "1", "1", "10", "5", "50%"]),
        (.regular, ["FA Cup", "4", "1", "2", "1", "6", "6", "25%"]),
        (.regular, ["Total", "57", "24", "17", "16", "90", "70", "42.1%"]),
    ]

    let leftAlignedColumns = [0]
    let rightAlignedColumns: [Int] = []

    var numberOfHeaderRows: Int {
        data.filter({ $0.type == .header }).count
    }
    var maxNumberOfColumns: Int {
        data.map({ $0.columns.count }).max() ?? 0
    }

    var selectedRow: Int?
    var selectedColumn: Int?

    lazy var dataTableColours: DataTableColours = {
        DataTableColours(headerBackground: .headerBackground,
                         primaryBackground: .primaryBackground,
                         secondaryBackground: .secondaryBackground,
                         headerText: .black,
                         regularText: .black,
                         alternatingColours: true,
                         headerBottomBorder: .headerCellBottomBorder,
                         regularBottomBorder: .regularBottomBorder,
                         highlightColour: .lightGray)
    }()

    lazy var layout: DataTableCollectionViewLayout = {
        let settings = DataTableLayoutSettings(maxCellWidth: 100,
                                               numberOfHeaderRows: numberOfHeaderRows,
                                               maxNumberOfColumns: maxNumberOfColumns,
                                               cellPadding: (top: 8, right: 8, bottom: 8, left: 8),
                                               numberOfStickyRows: 2,
                                               numberOfStickyColumns: 1)
        let layout = DataTableCollectionViewLayout(settings: settings)
        layout.dataProvider = self
        return layout
    }()

    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        collectionView.register(UINib(nibName:"DataTableCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:reuseIdentifier)

        collectionView.backgroundColor = .white
        collectionView.bounces = false

        collectionView.collectionViewLayout = layout
    }
}

// MARK: UICollectionViewDataSource
extension DataTableCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].columns.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? DataTableCollectionViewCell else { return UICollectionViewCell() }
        let text = textForCell(at: indexPath)

        cell.textLabel.attributedText = text
        cell.textLabelTopConstraint.constant = layout.settings.cellPadding.top
        cell.textLabelTrailingConstraint.constant = layout.settings.cellPadding.right
        cell.textLabelBottomConstraint.constant = layout.settings.cellPadding.bottom
        cell.textLabelLeadingConstraint.constant = layout.settings.cellPadding.left

        if leftAlignedColumns.contains(indexPath.row) && indexPath.section >= numberOfHeaderRows {
            cell.textLabel.textAlignment = .left
        } else if rightAlignedColumns.contains(indexPath.row) && indexPath.section >= numberOfHeaderRows {
            cell.textLabel.textAlignment = .right
        } else {
            cell.textLabel.textAlignment = .center
        }

        let isHeaderRow = indexPath.section < numberOfHeaderRows
        if isHeaderRow {
            cell.backgroundColor = dataTableColours.headerBackground
        } else if dataTableColours.alternatingColours {
            let isPrimaryRow = (indexPath.section - numberOfHeaderRows) % 2 == 0
            cell.backgroundColor = isPrimaryRow ? dataTableColours.primaryBackground : dataTableColours.secondaryBackground
        } else {
            cell.backgroundColor = dataTableColours.primaryBackground
        }

        cell.bottomBorderView.backgroundColor = isHeaderRow ? dataTableColours.headerBottomBorder : dataTableColours.regularBottomBorder

        cell.selectedBackgroundView = {
            let bgview = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height))
            bgview.backgroundColor = dataTableColours.highlightColour
            return bgview
        }()

        cell.isSelected = indexPath.row == selectedColumn || indexPath.section == selectedRow

        return cell
    }

    private func fontWeightForCell(in section: Int) -> UILegibilityWeight {
        if isHeaderSection(section) || isLastSection(section) {
            return .bold
        }
        return .regular
    }

    private func isHeaderSection(_ section: Int) -> Bool {
        section < numberOfHeaderRows
    }
    private func isLastSection(_ section: Int) -> Bool {
        section == collectionView.numberOfSections - 1
    }
}

// MARK: UICollectionViewDelegate
extension DataTableCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedRow == indexPath.section && selectedColumn == indexPath.row {
            selectedRow = nil
            selectedColumn = nil
            for cell in collectionView.visibleCells { cell.isSelected = false }
            collectionView.deselectItem(at: indexPath, animated: false)
            return
        }
        selectedRow = indexPath.section
        selectedColumn = indexPath.row
        for cell in collectionView.visibleCells { cell.isSelected = false }
        for i in numberOfHeaderRows..<data.count {
            let cell = collectionView.cellForItem(at: IndexPath(row: indexPath.row, section: i))
            cell?.isSelected = true
        }
        for i in 0..<maxNumberOfColumns {
            let cell = collectionView.cellForItem(at: IndexPath(row: i, section: indexPath.section))
            cell?.isSelected = true
        }
    }
}

// MARK: TableDataProviding
extension DataTableCollectionViewController: TableDataProviding {
    func textForCell(at indexPath: IndexPath) -> NSAttributedString? {
        guard indexPath.section < data.count && indexPath.row < data[indexPath.section].columns.count else { return nil }
        let cellType = data[indexPath.section].type
        let textString = data[indexPath.section].columns[indexPath.row]
        let foregroundColor: UIColor
        let font: UIFont
        if cellType == .header {
            foregroundColor = dataTableColours.headerText
            font = UIFont.boldSystemFont(ofSize: 14.0)
        } else {
            foregroundColor = dataTableColours.regularText
            font = UIFont.systemFont(ofSize: 14.0)
        }
        return NSAttributedString(string: textString, attributes: [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: foregroundColor
        ])
    }
}
