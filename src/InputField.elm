module InputField exposing (inputField)

import FormTypes exposing (..)
import FormUpdate exposing (getField)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


inputField :
    FieldName
    -> FieldType
    -> Model
    -> Maybe FieldValidator
    -> (FieldName -> Maybe FieldValidator -> FieldValue -> Msg)
    -> (FieldName -> Msg)
    -> Html Msg
inputField fName fType model validator toChange toTouch =
    let
        field =
            getField fName model
    in
    label []
        [ input
            [ name fName
            , type_ fType
            , value field.value
            , onInput (toChange fName validator)
            , onBlur (toTouch fName)
            ]
            []
        , viewError field.error
        ]


viewError : FieldError -> Html Msg
viewError e =
    div []
        [ text e
        ]
