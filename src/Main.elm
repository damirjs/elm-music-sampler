module Main exposing (main)

import Browser
import Debug
import Dict exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)



-- MODEL


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


initialModel : Model
initialModel =
    Dict.fromList
        [ ( "password", Field False "" "" )
        , ( "passwordRepeat", Field False "" "" )
        ]



-- UPDATE


type Msg
    = FieldChange FieldName FieldError FieldValue
    | FieldTouch FieldName


update : Msg -> Model -> Model
update msg model =
    case msg of
        FieldChange field error value ->
            Dict.update field (nextValue error value) model

        FieldTouch field ->
            Dict.update field setTouched model


getField : FieldName -> Model -> Field
getField n m =
    case Dict.get n m of
        Just a ->
            a

        Nothing ->
            Field False "" ""


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
            Just { oldValue | value = value, error = error }

        Nothing ->
            Just (Field True "" "")


pwdConfValidator : Model -> FieldError
pwdConfValidator m =
    Debug.log "res"
        (let
            pwd =
                .value (getField "password" m)

            pwdRepeat =
                .value (getField "passwordRepeat" m)
         in
         if Debug.log "pwd" pwd /= Debug.log "pwdR" pwdRepeat then
            "Passwords doesn't match"

         else
            ""
        )


view : Model -> Html Msg
view model =
    Html.form []
        [ div []
            [ div [] [ text (Debug.toString model) ]
            , div []
                [ inputField "password" "text" model Nothing FieldChange FieldTouch
                ]
            , div []
                [ inputField "passwordRepeat" "text" model (Just pwdConfValidator) FieldChange FieldTouch
                ]
            ]
        ]


handleValidator : Maybe FieldValidator -> Model -> String
handleValidator v m =
    case v of
        Just validator ->
            validator m

        Nothing ->
            ""


viewError : FieldError -> Html Msg
viewError e =
    div []
        [ text e
        ]


inputField :
    FieldName
    -> FieldType
    -> Model
    -> Maybe FieldValidator
    -> (FieldName -> FieldError -> FieldValue -> Msg)
    -> (FieldName -> Msg)
    -> Html Msg
inputField fName fType model validate toChange toTouch =
    let
        field =
            getField fName model
    in
    label []
        [ input
            [ name fName
            , type_ fType
            , value field.value
            , onInput (toChange fName (handleValidator validate model))
            , onBlur (toTouch fName)
            ]
            []
        , viewError field.error
        ]



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel, view = view, update = update }
