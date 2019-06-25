module FormTypes exposing (Field, FieldError, FieldName, FieldType, FieldValidator, FieldValue, Model, Msg(..))

import Dict exposing (..)


type alias FieldName =
    String


type alias FieldValue =
    String


type alias FieldError =
    String


type alias FieldType =
    String


type alias Field =
    { touched : Bool
    , value : FieldValue
    , error : FieldError
    }


type alias FieldValidator =
    Model -> FieldError


type alias Model =
    Dict FieldName Field


type Msg
    = FieldChange FieldName (Maybe FieldValidator) FieldValue
    | FieldTouch FieldName
