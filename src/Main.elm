module Main exposing (main)

import Browser
import Debug
import FormTypes exposing (..)
import FormUpdate exposing (..)
import Html exposing (..)
import InputField exposing (..)


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



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox
        { init = FormUpdate.initialModel, view = view, update = FormUpdate.update }
