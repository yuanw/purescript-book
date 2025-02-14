module Data.AddressBook where

import Prelude

import Data.Argonaut (class DecodeJson, class EncodeJson)
import Data.Argonaut.Decode.Generic (genericDecodeJson)
import Data.Argonaut.Encode.Generic (genericEncodeJson)
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)

type Address =
  { street :: String
  , city :: String
  , state :: String
  }

address :: String -> String -> String -> Address
address street city state = { street, city, state }

data PhoneType
  = HomePhone
  | WorkPhone
  | CellPhone
  | OtherPhone

derive instance genericPhoneType :: Generic PhoneType _

instance encodeJsonPhoneType :: EncodeJson PhoneType where
  encodeJson = genericEncodeJson

instance decodeJsonPhoneType :: DecodeJson PhoneType where
  decodeJson = genericDecodeJson

instance showPhoneType :: Show PhoneType where
  show = genericShow

type PhoneNumber =
  { "type" :: PhoneType
  , number :: String
  }

phoneNumber :: PhoneType -> String -> PhoneNumber
phoneNumber ty number =
  { "type": ty
  , number: number
  }

type Person =
  { firstName :: String
  , lastName :: String
  , homeAddress :: Address
  , phones :: Array PhoneNumber
  }

person :: String -> String -> Address -> Array PhoneNumber -> Person
person firstName lastName homeAddress phones = { firstName, lastName, homeAddress, phones }

examplePerson :: Person
examplePerson =
  person "John" "Smith"
    (address "123 Fake St." "FakeTown" "CA")
    [ phoneNumber HomePhone "555-555-5555"
    , phoneNumber CellPhone "555-555-0000"
    ]
