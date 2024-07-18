import SwiftUI

struct AsyncImageLoader: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Image
    private let fallbackImage: Image

    init(url: String, placeholder: Image = Image(systemName: "photo"), fallbackImage: Image = Image("dummyBookImage")) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
        self.placeholder = placeholder
        self.fallbackImage = fallbackImage
    }

    var body: some View {
        ZStack {
            switch loader.state {
            case .loading:
                ProgressView()
                    .frame(width: 80, height: 115)
            case .failure:
                fallbackImage
                    .resizable()
                    .frame(width: 80, height: 115)
                    .cornerRadius(5)
            case .success(let image):
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 80, height: 115)
                    .cornerRadius(5)
            }
        }
        .frame(width: 80, height: 115)
        .cornerRadius(5)
    }
}

class ImageLoader: ObservableObject {
    enum LoadState {
        case loading, success(UIImage), failure
    }

    @Published var state = LoadState.loading

    init(url: String) {
        guard let url = URL(string: url) else {
            print("Invalid URL: \(url)")
            self.state = .failure
            return
        }

        print("Fetching image from URL: \(url)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching image: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.state = .failure
                }
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.state = .success(image)
                }
            } else {
                print("Failed to load image data")
                DispatchQueue.main.async {
                    self.state = .failure
                }
            }
        }.resume()
    }
}
