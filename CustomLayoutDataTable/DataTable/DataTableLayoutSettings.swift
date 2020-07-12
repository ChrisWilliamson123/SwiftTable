import UIKit

struct DataTableLayoutSettings {
    typealias CellPadding = (top: CGFloat, right: CGFloat, bottom: CGFloat, left: CGFloat)

    let maxCellWidth: CGFloat
    let numberOfHeaderRows: Int
    let maxNumberOfColumns: Int
    let cellPadding: CellPadding
    let numberOfStickyRows: Int
    let numberOfStickyColumns: Int
}
