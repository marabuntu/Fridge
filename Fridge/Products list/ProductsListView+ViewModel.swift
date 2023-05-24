import Foundation

extension ProductsListView {

    class ViewModel: ObservableObject {
        @Published private(set) var products = [Product]()

        init() {
            setupObserving()
            fetchProducts()
        }

        private func setupObserving() {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(onCoreDataUpdate),
                name: Notification.Name.coreDataUpdate,
                object: nil)
        }

        @objc
        private func onCoreDataUpdate() {
            fetchProducts()
        }

        func fetchProducts() {
            CoreDataManager.shared.allProducts {
                let current = Date()
                self.products = $0.sorted { $0.coreDataExpirationDate ?? current < $1.coreDataExpirationDate ?? current }
            }
        }

        func product(code: String) -> Product? {
            CoreDataManager.shared.product(withBarcode: code)
        }

        func storeProducts() {
            CoreDataManager.shared.storeProducts()
        }

        func removeProduct(_ product: Product) {
            CoreDataManager.shared.removeProduct(product)
        }

        func createProduct() -> Product {
            CoreDataManager.shared.createProduct()
        }
    }
}
