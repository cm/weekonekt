module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (..)
import WebSocket exposing (..)
import Json.Encode exposing (..)


type alias Flags =
    { apiHost : String
    }


type alias Model =
    { flags : Flags
    , message : String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { flags = flags, message = "" }, WebSocket.send (wsUrl flags) (encodeText "Hello") )


encodeText : String -> String
encodeText str =
    Json.Encode.encode 0
        (Json.Encode.object
            [ ( "message", string str )
            ]
        )


wsUrl : Flags -> String
wsUrl flags =
    "ws://" ++ flags.apiHost ++ "/ws"


type Msg
    = NoOp
    | WsMsg String
    | WsPing


view : Model -> Html Msg
view model =
    div []
        [ headerSection model
        , contactSection model
        , footerSection model
        ]


headerSection : Model -> Html Msg
headerSection model =
    div [] [ text "Hello Pedro 2" ]


contactSection : Model -> Html Msg
contactSection model =
    div [] []


footerSection : Model -> Html Msg
footerSection model =
    div [] []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        WsMsg str ->
            ( { model | message = str }, Cmd.none )

        WsPing ->
            ( model, WebSocket.send (wsUrl model.flags) (encodeText "Hello there") )


subscriptions : Model -> Sub Msg
subscriptions model =
    WebSocket.listen (wsUrl model.flags) WsMsg


main : Program Flags Model Msg
main =
    programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
