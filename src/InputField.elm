module InputField exposing (inputField)

import FormTypes exposing (..)
import FormUpdate exposing (getField)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias InputFieldOptions =
    { fName : FieldName
    , fType : FieldType
    , model : Model
    , validator : Maybe FieldValidator
    , toChangeMsg : FieldName -> Maybe FieldValidator -> FieldValue -> Msg
    , toTouchMsg : FieldName -> Msg
    }


inputField :
    InputFieldOptions
    -> Html Msg
inputField { fName, fType, model, validator, toChangeMsg, toTouchMsg } =
    let
        field =
            getField fName model
    in
    label []
        [ input
            [ name fName
            , type_ fType
            , value field.value
            , onInput (toChangeMsg fName validator)
            , onBlur (toTouchMsg fName)
            ]
            []
        , viewError field.error
        ]


viewError : Maybe TextError -> Html Msg
viewError e =
    div []
        [ case e of
            Just textError ->
                let
                    (TextError v) =
                        textError
                in
                text v

            Nothing ->
                text ""
        ]
