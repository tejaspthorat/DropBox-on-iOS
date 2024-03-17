// swiftlint:disable all
import Amplify
import Foundation

public struct DigitalBoxDocumentData: Model {
  public let id: String
  public var name: String?
  public var metadata: String?
  public var key: String
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      name: String? = nil,
      metadata: String? = nil,
      key: String) {
    self.init(id: id,
      name: name,
      metadata: metadata,
      key: key,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      name: String? = nil,
      metadata: String? = nil,
      key: String,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.name = name
      self.metadata = metadata
      self.key = key
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}