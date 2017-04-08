module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (..)


type alias Model =
    String


init : ( Model, Cmd Msg )
init =
    ( "Hello", Cmd.none )


type Msg
    = NoOp


view : Model -> Html Msg
view model =
    div []
        [ headerSection model
        , bannerSection model
        ]


headerSection : Model -> Html Msg
headerSection model =
    header []
        [ nav [ class "navbar navbar-default navbar-main navbar-fixed-top", role "navigation" ]
            [ div [ class "container" ]
                [ div [ class "navbar-header" ]
                    [ button
                        [ type_ "button"
                        , class "navbar-toggle"
                        , attribute "data-toggle" "collapse"
                        , attribute "data-target" ".navbar-ex1-collapse"
                        ]
                        []
                    , a [ class "", href "#" ] []
                    ]
                , div [ class "collapse navbar-collapse navbar-ex1-collapse" ]
                    [ ul [ class "nav navbar-nav navbar-right" ]
                        [ li [ class "active dropdown singleDrop" ]
                            [ a [ href "#" ] [ text "Home" ] ]
                        , li [ class "dropdown singleDrop" ]
                            [ a [ href "#" ] [ text "Sign In" ] ]
                        , li [ class "dropdown singleDrop" ]
                            [ a [ href "#" ] [ text "Register" ] ]
                        ]
                    ]
                ]
            ]
        ]


bannerSection : Model -> Html Msg
bannerSection model =
    section [ class "bannercontainer" ]
        [ div [ class "fullscreenbanner-container" ]
            [ div [ class "fullscreenbanner" ]
                [ ul []
                    (List.map bannerSlideView
                        [ ( "01", "PlopI haven't been everywhere", "but it's on my list", "Susan Sontag" )
                        , ( "02", "Traveling – it leaves you speechless", "then turns you into a storyteller", "Ibn Battuta" )
                        ]
                    )
                ]
            ]
        ]


bannerSlideView : ( String, String, String, String ) -> Html Msg
bannerSlideView ( slide, quote1, quote2, author ) =
    li
        [ attribute "data-transition" "parallaxvertical"
        , attribute "data-slotamount" "5"
        , attribute "data-masterspeed" "700"
        , attribute "data-title" "Slide 1"
        ]
        [ img
            [ src ("./img/slider/slider-" ++ slide ++ ".jpg")
            , alt "slidebg1"
            , attribute "data-bgfit" "cover"
            , attribute "data-bgposition" "center center"
            , attribute "data-bgrepeat" "no-repeat"
            ]
            []
        , div [ class "slider-caption container" ]
            [ div
                [ class "tp-caption rs-caption-1 sft start"
                , attribute "data-hoffset" "0"
                , attribute "data-y" "270"
                , attribute "data-speed" "800"
                , attribute "data-start" "1000"
                , attribute "data-easing" "Back.easeInOut"
                , attribute "data-endspeed" "300"
                ]
                [ text quote1
                , span [] [ text quote2 ]
                ]
            , div
                [ class "tp-caption rs-caption-2 sft"
                , attribute "data-hoffset" "0"
                , attribute "data-y" "400"
                , attribute "data-speed" "1000"
                , attribute "data-start" "1500"
                , attribute "data-easing" "Power4.easeOut"
                , attribute "data-endspeed" "300"
                , attribute "data-endeasing" "Power1.easeIn"
                , attribute "data-captionhidden" "off"
                ]
                [ text author ]
            , div
                [ class "tp-caption rs-caption-3 sft"
                , attribute "data-hoffset" "0"
                , attribute "data-y" "485"
                , attribute "data-speed" "800"
                , attribute "data-start" "2000"
                , attribute "data-easing" "Power4.easeOut"
                , attribute "data-endspeed" "300"
                , attribute "data-endeasing" "Power1.easeIn"
                , attribute "data-captionhidden" "off"
                ]
                [ span [ class "page-scroll" ]
                    [ a [ class "btn buttonCustomPrimary" ]
                        [ text "Join Now" ]
                    ]
                ]
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
