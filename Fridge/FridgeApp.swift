import SwiftUI

@main
struct FridgeApp: App {

    var body: some Scene {
        WindowGroup {
            ProductsListView(viewModel: ProductsListView.ViewModel())
        }
    }
}
