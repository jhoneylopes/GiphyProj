public struct GIFModelDTO: Codable, Equatable, Hashable {
    public let id: String
    public let images: Images?

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: GIFModelDTO, rhs: GIFModelDTO) -> Bool {
        return lhs.id == rhs.id
    }
}

public struct Images: Codable, Equatable {
    public let downsized: GIF?
}

public struct GIF: Codable, Equatable {
    public let url: String?
}
