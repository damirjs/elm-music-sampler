module FormUpdate exposing (getField, initialModel, update)

import Dict exposing (..)
import FormTypes exposing (..)


initialModel : Model
initialModel =
    Dict.fromList
        [ ( "password", Field False "" "" )
        , ( "passwordRepeat", Field False "" "" )
        ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        FieldChange field validator value ->
            Dict.update field (nextValue (handleValidator validator model) value) model

        FieldTouch field ->
            Dict.update field setTouched model


handleValidator : Maybe FieldValidator -> Model -> String
handleValidator v m =
    case v of
        Just validator ->
            validator m

        Nothing ->
            ""


setTouched : Maybe Field -> Maybe Field
setTouched oldField =
    case oldField of
        Just oldValue ->
            Just { oldValue | touched = True }

        Nothing ->
            Just (Field True "" "")


nextValue : FieldError -> FieldValue -> Maybe Field -> Maybe Field
nextValue error value oldField =
    case oldField of
        Just oldValue ->
            Just { oldValue | value = value, error = Debug.log "inNextValue" error }

        Nothing ->
            Just (Field True "" "")


getField : FieldName -> Model -> Field
getField n m =
    case Dict.get n m of
        Just a ->
            a

        Nothing ->
            Field False "" ""
