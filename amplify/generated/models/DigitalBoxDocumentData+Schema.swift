// swiftlint:disable all
import Amplify
import Foundation

extension DigitalBoxDocumentData {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case name
    case metadata
    case key
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let digitalBoxDocumentData = DigitalBoxDocumentData.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "owner", identityClaim: "cognito:username", provider: .userPools, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "DigitalBoxDocumentData"
    model.syncPluralName = "DigitalBoxDocumentData"
    
    model.attributes(
      .primaryKey(fields: [digitalBoxDocumentData.id])
    )
    
    model.fields(
      .field(digitalBoxDocumentData.id, is: .required, ofType: .string),
      .field(digitalBoxDocumentData.name, is: .optional, ofType: .string),
      .field(digitalBoxDocumentData.metadata, is: .optional, ofType: .string),
      .field(digitalBoxDocumentData.key, is: .required, ofType: .string),
      .field(digitalBoxDocumentData.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(digitalBoxDocumentData.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension DigitalBoxDocumentData: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}