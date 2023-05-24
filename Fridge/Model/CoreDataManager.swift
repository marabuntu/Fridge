import CoreData

class CoreDataManager {
    private var container = NSPersistentContainer(name: Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "")
    private var context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    private var configured = false

    static let shared = CoreDataManager()

    // MARK: - Private

    private init() {}

    private func configure(configurationDone: @escaping () -> ()) {
        if configured {
            configurationDone()
            return
        }
        container.loadPersistentStores { _, error in
            self.context = self.container.viewContext
            self.configured = true
            configurationDone()
            debugPrint(error ?? "")
        }
    }

    private func sendDataUpdatedNotification() {
        NotificationCenter.default.post(name: Notification.Name.coreDataUpdate, object: nil, userInfo: nil)
    }

    // MARK: - Public

    func allProducts(completion: @escaping ([Product]) -> ()) {
        configure {
            if let products = try? self.context.fetch(NSFetchRequest<Product>(entityName: String(describing: Product.self))) {
                completion(products)
                return
            }
            completion([])
        }
    }

    func product(withBarcode code: String) -> Product? {
        let fetchRequest = NSFetchRequest<Product>(entityName: String(describing: Product.self))
        fetchRequest.predicate = NSPredicate(format: "\(NSExpression(forKeyPath: \Product.coreDataBarcode).keyPath) == %@", code)
        fetchRequest.fetchLimit = 1
        let products = try? context.fetch(fetchRequest)
        return products?.first
    }

    func storeProducts() {
        if context.hasChanges {
            try? context.save()
            sendDataUpdatedNotification()
        }
    }

    func removeProduct(_ product: Product) {
        context.delete(product)
        sendDataUpdatedNotification()
    }

    func createProduct() -> Product {
        Product(context: context)
    }

    func setForAllProducts(withBarCode code: String, name: String) {
        guard !code.isEmpty,
              !name.isEmpty,
              let products = try? self.context.fetch(NSFetchRequest<Product>(entityName: String(describing: Product.self))) else {
            return
        }
        for product in products where product.barcode == code {
            product.name = name
        }
    }
}
