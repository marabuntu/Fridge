extension AddProductView {

    class ViewModel {
        private(set) var product: Product
        var isProductAddingCancelled = true

        init(product: Product) {
            self.product = product
        }

        func onViewDissapear() {
            if isProductAddingCancelled {
                CoreDataManager.shared.removeProduct(product)
            } else {
                updateAllProductNames()
            }
            CoreDataManager.shared.storeProducts()
        }

        private func updateAllProductNames() {
            guard let barcode = product.barcode,
                  !product.name.isEmpty else {
                return
            }
            CoreDataManager.shared.setForAllProducts(withBarCode: barcode, name: product.name)
        }
    }
}
