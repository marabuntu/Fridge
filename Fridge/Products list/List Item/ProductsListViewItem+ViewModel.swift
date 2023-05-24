import SwiftUI

extension ProductsListViewItem {

    class ViewModel: ObservableObject {
        @Published private(set) var product: Product

        init(product: Product) {
            self.product = product
        }
    }
}
