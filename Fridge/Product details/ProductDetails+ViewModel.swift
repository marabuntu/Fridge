extension ProductDetails {

    class ViewModel {
        private(set) var product: Product

        init(product: Product) {
            self.product = product
        }

        func storeProducts() {
            CoreDataManager.shared.storeProducts()
        }
    }
}
