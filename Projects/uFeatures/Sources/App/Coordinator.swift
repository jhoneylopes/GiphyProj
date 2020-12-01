protocol Coordinator: AnyObject {
    func start()
}

extension Coordinator {
    var identifier: String {
        return String(describing: self)
    }
}
