import CoreData

@objc(Product)
public class Product: NSManagedObject, Identifiable {
    @NSManaged public var coreDataName: String?
    @NSManaged public var coreDataExpirationDate: Date?
    @NSManaged public var coreDataBarcode: String?

    public let id = UUID()
    var onUpdate: ((Product) -> ())?

    var expirationDate: Date? {
        get { coreDataExpirationDate }
        set {
            coreDataExpirationDate = newValue
            onUpdate?(self)
        }
    }

    var name: String {
        get { coreDataName ?? "" }
        set {
            coreDataName = newValue
            onUpdate?(self)
        }
    }

    var expirationDateString: String {
        get { coreDataExpirationDate?.defaultFormatted() ?? "" }
    }

    var barcode: String? {
        get { coreDataBarcode }
        set {
            coreDataBarcode = newValue
            onUpdate?(self)
        }
    }

    var isValid: Bool {
        guard let expirationDate = coreDataExpirationDate else { return false }
        let calendar = Calendar.current
        let expirationYear = calendar.component(.year, from: expirationDate)
        let currentYear = calendar.component(.year, from: Date())
        return !(coreDataName?.isEmpty ?? true) && expirationYear >= currentYear
    }

    var isExpired: Bool {
        guard let expirationDate = coreDataExpirationDate else { return true }
        return expirationDate < Date()
    }
}
