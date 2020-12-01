public struct SearchResult<T: Decodable>: Decodable {
    public let data: [T]
    public var pagination: Pagination?
    public var meta: Meta?
}

public struct Pagination: Decodable {
    let total_count: Int
    let count: Int
    let offset: Int
}

public struct Meta: Decodable {
    let status: Int
    let msg: String
    let response_id: String
}
