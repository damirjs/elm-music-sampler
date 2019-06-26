module FormUpdate exposing (getField, initialModel, update)

import Dict exposing (..)
import FormTypes exposing (..)
import Platform.Cmd


initialModel : Model
initialModel =
    Dict.fromList
        [ ( "password", Field False "" Nothing )
        , ( "passwordRepeat", Field False "" Nothing )
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FieldChange field validator value ->
            ( Dict.update field (nextValue (validate validator model) value) model, Cmd.none )

        FieldTouch field ->
            ( Dict.update field setTouched model, Cmd.none )


validate : Maybe FieldValidator -> Model -> Maybe TextError
validate maybeVal m =
    case maybeVal of
        Just validator ->
            let
                (ValidationResult result) =
                    validator m
            in
            case result of
                Err textError ->
                    Just textError

                Ok _ ->
                    Nothing

        Nothing ->
            Nothing


setTouched : Maybe Field -> Maybe Field
setTouched oldField =
    case oldField of
        Just oldValue ->
            Just { oldValue | touched = True }

        Nothing ->
            Just (Field True "" Nothing)


nextValue : Maybe TextError -> FieldValue -> Maybe Field -> Maybe Field
nextValue error value oldField =
    case oldField of
        Just oldValue ->
            Just { oldValue | value = value, error = Debug.log "nextErrorValue" error }

        Nothing ->
            Just (Field True "" Nothing)


getField : FieldName -> Model -> Field
getField n m =
    case Dict.get n m of
        Just a ->
            a

        Nothing ->
            Field False "" Nothing
