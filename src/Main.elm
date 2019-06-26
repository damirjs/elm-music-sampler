module Main exposing (main)

import Browser
import Debug
import FormTypes exposing (..)
import FormUpdate exposing (..)
import Html exposing (..)
import InputField exposing (..)
import Platform.Cmd
import Platform.Sub


pwdConfValidator : Model -> ValidationResult
pwdConfValidator m =
    Debug.log "validator res"
        (let
            pwd =
                .value (getField "password" m)

            pwdRepeat =
                .value (getField "passwordRepeat" m)
         in
         if Debug.log "pwd" pwd /= Debug.log "pwdR" pwdRepeat then
            ValidationResult (Err (TextError "Passwords doesn't match"))

         else
            ValidationResult (Ok True)
        )


view : Model -> Html Msg
view model =
    Html.form []
        [ div []
            [ div [] [ text (Debug.toString model) ]
            , div []
                [ inputField
                    { fName = "password"
                    , fType = "text"
                    , model = model
                    , validator = Nothing
                    , toChangeMsg = FieldChange
                    , toTouchMsg = FieldTouch
                    }
                ]
            , div []
                [ inputField
                    { fName = "passwordRepeat"
                    , fType = "text"
                    , model = model
                    , validator = Just pwdConfValidator
                    , toChangeMsg = FieldChange
                    , toTouchMsg = FieldTouch
                    }
                ]
            ]
        ]



-- MAIN


init : () -> ( Model, Cmd Msg )
init () =
    ( FormUpdate.initialModel, Cmd.none )


subscriptions _ =
    Sub.none


main : Program () Model Msg
main =
    Browser.element { init = init, view = view, update = FormUpdate.update, subscriptions = subscriptions }
