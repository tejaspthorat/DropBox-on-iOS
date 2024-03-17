// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "f195932fadb0c31a40bf880633cf544c"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: DigitalBoxDocumentData.self)
  }
}