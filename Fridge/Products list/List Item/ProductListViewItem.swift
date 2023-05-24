import SwiftUI

struct ProductsListViewItem: View {
    let viewModel: ViewModel

    var body: some View {
        HStack {
            Text(viewModel.product.name).layoutPriority(1)
            Spacer().layoutPriority(1)
            Text(viewModel.product.expirationDateString).layoutPriority(1)
            NavigationLink(destination: ProductDetails(viewModel: ProductDetails.ViewModel(product: viewModel.product))) { }
        }
    }
}

struct ProductsListViewItem_Previews: PreviewProvider {

    static var previews: some View {
        return ProductsListViewItem(viewModel: ProductsListViewItem.ViewModel(product: Product()))
    }
}
