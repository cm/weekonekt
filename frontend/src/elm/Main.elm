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


type alias Place =
    { country : String
    , area : String
    , location : String
    }


type alias Places =
    List Place


type alias Category =
    { name : String
    , icon : String
    }


type alias Categories =
    List Category


type Step
    = Home
    | Categories


type Mode
    = FindMode
    | RecommendMode


type alias Model =
    { flags : Flags
    , step : Step
    , mode : Maybe Mode
    , keywords : String
    , places : Places
    , place : Maybe Place
    , categories : Categories
    , category : Maybe Category
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initModel flags, WebSocket.send (wsUrl flags) (encodeText "Hello") )


initModel : Flags -> Model
initModel flags =
    { flags = flags
    , step = Home
    , mode = Nothing
    , keywords = ""
    , places = allPlaces
    , place = Nothing
    , categories = allCategories
    , category = Nothing
    }


allPlaces : Places
allPlaces =
    [ { country = "Indonesia", area = "Bali", location = "Denpasar" }
    , { country = "Indonesia", area = "Bali", location = "Jimbaran" }
    , { country = "Indonesia", area = "Bali", location = "Kuta" }
    , { country = "Indonesia", area = "Bali", location = "Negara" }
    , { country = "Indonesia", area = "Bali", location = "Singaraja" }
    , { country = "Indonesia", area = "Bali", location = "Ubud" }
    ]


allCategories : Categories
allCategories =
    [ { name = "Accomodation", icon = "pe-7s-home" }
    , { name = "Transportation", icon = "pe-7s-car" }
    , { name = "Food & Beverage", icon = "pe-7s-wine" }
    , { name = "Activities", icon = "pe-7s-photo" }
    , { name = "Shopping", icon = "pe-7s-cart" }
    , { name = "Health", icon = "pe-7s-like" }
    ]


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
    | Keywords String
    | SelectPlace Place
    | Find
    | Recommend
    | WsMsg String
    | WsPing


view : Model -> Html Msg
view model =
    case model.step of
        Home ->
            homeView model

        Categories ->
            case ( model.mode, model.place ) of
                ( Just m, Just p ) ->
                    categoriesView m p model

                _ ->
                    errorView "Missing mode or place"


homeView : Model -> Html Msg
homeView model =
    div []
        [ headerSection model
        , startSection model
        , featuresSection model
        , footerSection model
        ]


categoriesView : Mode -> Place -> Model -> Html Msg
categoriesView m p model =
    div []
        [ headerSection model
        , categoriesSection m p model.categories
        , footerSection model
        ]


errorView : String -> Html Msg
errorView msg =
    div []
        [ text ("Error: " ++ msg)
        ]


headerSection : Model -> Html Msg
headerSection model =
    div [ id "sticky-nav-sticky-wrapper", class "sticky-wrapper", style [ ( "height", "92px" ) ] ]
        [ div [ class "navbar navbar-custom sticky", role "navigation", id "sticky-nav" ]
            [ div [ class "container" ]
                [ div [ class "navbar-header" ]
                    [ button
                        [ type_ "button"
                        , class "navbar-toggle"
                        , attribute "data-toggle" "collapse"
                        , attribute "data-target" ".navbar-collapse"
                        ]
                        [ span [ class "sr-only" ] [ text "Toggle navigation" ]
                        , span [ class "icon-bar" ] []
                        , span [ class "icon-bar" ] []
                        , span [ class "icon-bar" ] []
                        ]
                    , a [ class "navbar-brand logo" ]
                        [ text "wee"
                        , span [] [ text "Konekt" ]
                        ]
                    ]
                , div [ class "navbar-collapse collapse", id "navbar-menu" ]
                    [ ul [ class "nav navbar-nav nav-custom-left" ] []
                    , ul [ class "nav navbar-nav navbar-right" ]
                        [ li [] [ a [] [ text "Login" ] ]
                        , li [] [ a [ class "btn btn-white-fill navbar-btn" ] [ text "Join now" ] ]
                        ]
                    ]
                ]
            ]
        ]


startSection : Model -> Html Msg
startSection model =
    section [ class "bg-custom home", id "home" ]
        [ div [ class "home-sm" ]
            [ div [ class "container" ]
                [ div [ class "row" ]
                    [ div [ class "col-md-6 col-sm-7" ]
                        [ div [ class "home-wrapper home-wrapper-alt p-0" ]
                            [ h1 [ class "h1 font-light text-white w-full" ]
                                [ text "Choose your destination"
                                ]
                            , h4 [ class "text-light w-full" ]
                                [ text "Where are you going? "
                                , span [] [ text "Find" ]
                                , text " what fellow travellers have recommended"
                                , br [] []
                                , text "Where have you been? Tell us what you would "
                                , span [] [ text "recommend" ]
                                , text "!"
                                ]
                            , Html.form []
                                [ div [ class "form-group m-b-0" ]
                                    [ placeSelectionInput model ]
                                ]
                            , div [ style [ ( "position", "relative" ), ( "z-index", "0" ) ] ]
                                (placeActionButtons
                                    model
                                )
                            , placesLiveText model.places model.keywords
                            ]
                        ]
                    , div [ class "col-md-4 col-md-offset-2 col-sm-5" ]
                        [ Html.form [ role "form", class "intro-form" ]
                            [ h3 [ class "text-center" ] [ text "Register for free" ]
                            , div [ class "form-group" ]
                                [ input [ type_ "text", class "form-control", placeholder "Full Name", required True ] []
                                ]
                            , div [ class "form-group" ]
                                [ input [ type_ "text", class "form-control", placeholder "Email Address", required True ] []
                                ]
                            , div [ class "form-group" ]
                                [ input [ type_ "text", class "form-control", placeholder "User name", required True ] []
                                ]
                            , div [ class "form-group" ]
                                [ input [ type_ "text", class "form-control", placeholder "Password", required True ] []
                                ]
                            , div [ class "form-group" ]
                                [ button [ type_ "submit", class "btn btn-custom btn-sm btn-block" ] [ text "Join Now" ]
                                ]
                            , span [ class "help-block m-b-0 m-t-20 text-muted" ]
                                [ small []
                                    [ text "By registering you agree the weeKonekt "
                                    , a [] [ text "Terms of Use" ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]


categoriesSection : Mode -> Place -> Categories -> Html Msg
categoriesSection mode place categories =
    section [ class "section bg-light", id "categories" ]
        [ div [ class "container" ]
            [ div [ class "row" ]
                [ div [ class "col-sm-12 text-center" ]
                    [ categorySelectionTitle mode
                    ]
                ]
            , div [ class "row" ]
                [ div [ class "col-sm-12 text-center" ]
                    [ h1 [ class "h1 w-full" ]
                        [ text (placeDescription place)
                        ]
                    ]
                ]
            , div [ class "row", style [ ( "margin-top", "50px" ) ] ]
                [ div [ class "col-sm-6" ]
                    [ div [ class "country-preview indonesia" ] []
                    ]
                , div [ class "col-sm-6" ]
                    [ ul [ class "categories" ]
                        (List.map categoryListItemView categories)
                    ]
                ]
            ]
        ]


categorySelectionTitle : Mode -> Html Msg
categorySelectionTitle mode =
    case mode of
        FindMode ->
            div []
                [ h1 [ class "w-full" ]
                    [ i [ class "pe-7s-search" ] [] ]
                , h1 [ class "h1 w-full" ]
                    [ text "Find" ]
                , h4 [ class "w-full" ]
                    [ text "What are you looking for?" ]
                ]

        RecommendMode ->
            div []
                [ h1 [ class "w-full" ]
                    [ i [ class "pe-7s-pen" ] [] ]
                , h1 [ class "h1 w-full" ]
                    [ text "Recommend" ]
                , h4 [ class "w-full" ]
                    [ text "What would you like to recommend?" ]
                ]


categorySelectionPlace : Place -> Html Msg
categorySelectionPlace place =
    div []
        [ h1 [ class "h1 w-full" ]
            [ i [ class "pe-7s-map-marker" ] []
            , text (placeDescription place)
            ]
        , div [ class "country-preview indonesia" ] []
        ]


categoryListItemView : Category -> Html Msg
categoryListItemView cat =
    li []
        [ a []
            [ i [ class cat.icon ] []
            , text cat.name
            ]
        ]


placeActionButtons : Model -> List (Html Msg)
placeActionButtons model =
    case model.place of
        Nothing ->
            [ a [ class "btn btn-white-bordered disabled" ] [ text "Find" ]
            , span [] [ text " " ]
            , a [ class "btn btn-white-bordered disabled" ] [ text "Recommend" ]
            ]

        Just p ->
            [ a [ class "btn btn-white-bordered", onClick Find ] [ text "Find" ]
            , span [] [ text " " ]
            , a [ class "btn btn-white-bordered", onClick Recommend ] [ text "Recommend" ]
            ]


placeSelectionInput : Model -> Html Msg
placeSelectionInput model =
    input [ type_ "text", class "form-control input-subscribe", placeholder "Enter a location", onInput Keywords, value (placeSelectionText model) ] []


placeSelectionText : Model -> String
placeSelectionText m =
    case m.place of
        Nothing ->
            m.keywords

        Just p ->
            placeDescription p


placesLiveText : Places -> String -> Html Msg
placesLiveText places k =
    case String.isEmpty k of
        True ->
            div [] []

        False ->
            case (filterPlaces k places) of
                [] ->
                    [ li [] [ text "No match" ] ] |> autocomplete

                filteredPlaces ->
                    (List.map
                        placeLiveTextListItem
                        filteredPlaces
                    )
                        |> autocomplete


autocomplete : List (Html Msg) -> Html Msg
autocomplete contents =
    div [ class "autocomplete" ]
        [ ul []
            contents
        ]


filterPlaces : String -> Places -> Places
filterPlaces k places =
    List.filter (matchPlace k) places


matchPlace : String -> Place -> Bool
matchPlace k p =
    String.contains
        (String.toLower k)
        (String.toLower
            (String.join " " [ p.country, p.area, p.location ])
        )


placeLiveTextListItem : Place -> Html Msg
placeLiveTextListItem p =
    li []
        [ a [ onClick (SelectPlace p) ]
            [ i [ class "pe-7s-map-marker" ] []
            , text " "
            , text (placeDescription p)
            ]
        ]


placeDescription : Place -> String
placeDescription p =
    p.location ++ ", " ++ p.area ++ " " ++ p.country


featuresSection : Model -> Html Msg
featuresSection model =
    div [ class "section bg-light", id "features" ]
        [ div [ class "container" ]
            [ div [ class "row" ]
                [ div [ class "col-sm-12 text-center" ]
                    [ h3 [ class "title" ] [ text "We connect you to the world" ]
                    , p [ class "text-muted sub-title" ]
                        [ span []
                            [ text "weeKonekt" ]
                        , text
                            " enables travellers and local citizens to share their recommendations about their past travel experiences or local favourite spots"
                        ]
                    ]
                ]
            , div [ class "row" ]
                [ div [ class "col-sm-4" ]
                    [ div [ class "features-box" ]
                        [ i [ class "pe-7s-search" ] []
                        , h4 [] [ text "Plan your next trip" ]
                        , p [ class "text-muted" ] [ text "Where are you going? Find recommendations from other travellers" ]
                        ]
                    ]
                , div [ class "col-sm-4" ]
                    [ div [ class "features-box" ]
                        [ i [ class "pe-7s-smile" ] []
                        , h4 [] [ text "Positive karma only" ]
                        , p [ class "text-muted" ] [ text "No negative stuff. Only positive reviews are allowed" ]
                        ]
                    ]
                , div [ class "col-sm-4" ]
                    [ div [ class "features-box" ]
                        [ i [ class "pe-7s-pen" ] []
                        , h4 [] [ text "Share your experience" ]
                        , p [ class "text-muted" ] [ text "Where have you been? Share your recommendations with the rest of the world" ]
                        ]
                    ]
                ]
            , div [ class "row" ]
                [ div [ class "col-sm-4" ]
                    [ div [ class "features-box" ]
                        [ i [ class "pe-7s-like2" ] []
                        , h4 [] [ text "Rate recommendations" ]
                        , p [ class "text-muted" ] [ text "Help us finding the best places to see, the best things to do" ]
                        ]
                    ]
                , div [ class "col-sm-4" ]
                    [ div [ class "features-box" ]
                        [ i [ class "pe-7s-users" ] []
                        , h4 [] [ text "Connect with others" ]
                        , p [ class "text-muted" ] [ text "Get in touch and seek personalised advice from fellow travellers" ]
                        ]
                    ]
                , div [ class "col-sm-4" ]
                    [ div [ class "features-box" ]
                        [ i [ class "pe-7s-cash" ] []
                        , h4 [] [ text "Monetarize your experience" ]
                        , p [ class "text-muted" ] [ text "Are you liking recommendations? Are your recommendations being liked? Are you giving advice to future travellers? Get paid for it!" ]
                        ]
                    ]
                ]
            ]
        ]


footerSection : Model -> Html Msg
footerSection model =
    footer [ class "bg-gray footer" ]
        [ div [ class "container" ]
            [ div [ class "row" ]
                [ div [ class "col-sm-12" ]
                    [ div [ class "footer-alt text-center" ]
                        [ p [ class "text-muted m-b-0" ]
                            [ text "2017 ® weeKonekt. All rights reserved."
                            ]
                        ]
                    ]
                ]
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Keywords k ->
            ( { model | keywords = k, place = Nothing }, Cmd.none )

        SelectPlace p ->
            ( { model | place = Just p, keywords = "" }, Cmd.none )

        Find ->
            ( { model | step = Categories, mode = Just FindMode }, Cmd.none )

        Recommend ->
            ( { model | step = Categories, mode = Just RecommendMode }, Cmd.none )

        WsMsg str ->
            ( model, Cmd.none )

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
