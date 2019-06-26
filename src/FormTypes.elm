module FormTypes exposing
    ( Field
    , FieldName
    , FieldType
    , FieldValidator
    , FieldValue
    , Model
    , Msg(..)
    , TextError(..)
    , ValidationResult(..)
    )

import Dict exposing (..)


type alias FieldName =
    String


type alias FieldValue =
    String


type alias FieldType =
    String


type TextError
    = TextError String


type alias Field =
    { touched : Bool
    , value : FieldValue
    , error : Maybe TextError
    }


type ValidationResult
    = ValidationResult (Result TextError Bool)


type alias FieldValidator =
    Model -> ValidationResult


type alias Model =
    Dict FieldName Field


type Msg
    = FieldChange FieldName (Maybe FieldValidator) FieldValue
    | FieldTouch FieldName
