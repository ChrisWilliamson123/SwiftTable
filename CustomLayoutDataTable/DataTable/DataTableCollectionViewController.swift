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

    var numberOfHeaderRows: Int {
        data.filter({ $0.type == .header }).count
    }
    var maxNumberOfColumns: Int {
        data.compactMap({ $0.columns.count }).max() ?? 0
    }

    lazy var dataTableColours: DataTableColours = {
        DataTableColours(headerBackground: .headerBackground,
                         primaryBackground: .primaryBackground,
                         secondaryBackground: .secondaryBackground,
                         headerText: .black,
                         regularText: .black,
                         alternatingColours: true,
                         headerBottomBorder: .headerCellBottomBorder,
                         regularBottomBorder: .regularBottomBorder)
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
        return maxNumberOfColumns
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? DataTableCollectionViewCell else { return UICollectionViewCell() }
        let text = textForCell(at: indexPath)

        cell.textLabel.attributedText = text
        cell.textLabelTopConstraint.constant = layout.settings.cellPadding.top
        cell.textLabelTrailingConstraint.constant = layout.settings.cellPadding.right
        cell.textLabelBottomConstraint.constant = layout.settings.cellPadding.bottom
        cell.textLabelLeadingConstraint.constant = layout.settings.cellPadding.left

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

// MARK: TableDataProviding
extension DataTableCollectionViewController: TableDataProviding {
    func textForCell(at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section < data.count && indexPath.row < data[indexPath.section].columns.count {
            let cellType = data[indexPath.section].type
            let textString = data[indexPath.section].columns[indexPath.row]
            if cellType == .header {
                return NSAttributedString(string: textString, attributes: [
                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14.0),
                    NSAttributedString.Key.foregroundColor: dataTableColours.headerText
                ])
            } else {
                return NSAttributedString(string: textString, attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0),
                    NSAttributedString.Key.foregroundColor: dataTableColours.regularText
                ])
            }
        } else {
            return nil
        }
    }
}
