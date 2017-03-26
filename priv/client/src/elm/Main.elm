module Main exposing (..)

import Models exposing (..)
import Messages exposing (..)
import Commands exposing (..)
import Update exposing (..)
import Views exposing (..)
import Html exposing (programWithFlags)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Flags Model Msg
main =
    programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Models.init
        flags
    , Cmd.batch
        [ fetchInfo
            flags
        ]
    )
