import UIKit

protocol TableDataProviding: class {
    func textForCell(at indexPath: IndexPath) -> NSAttributedString?
}
