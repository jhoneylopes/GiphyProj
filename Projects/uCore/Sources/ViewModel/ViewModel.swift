public protocol ViewModel {
    associatedtype Input
    associatedtype Output
    var transform: (Input) -> Output { get }
    init(transform: @escaping (Input) -> Output)
}

protocol TranslationSource {
    associatedtype Destination
    static func translate(from source: Self) -> Destination
}

protocol TranslationDestination {
    associatedtype Source
    static func translate(from source: Source) -> Self
}

protocol Composable {
    func composed(with part: Self) -> Self
}

extension ViewModel where Self.Output: Composable {
    func composed<V: ViewModel>(with part: V) -> Self where
        V.Input: TranslationDestination, V.Input.Source == Self.Input,
        V.Output: TranslationSource, V.Output.Destination == Self.Output {
        return Self { input in
            let output = part.transform(V.Input.translate(from: input))
            let translatedOutput = V.Output.translate(from: output)
            let baseOutput = self.transform(input)
            return baseOutput.composed(with: translatedOutput)
        }
    }
}
