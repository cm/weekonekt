module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (..)
import WebSocket exposing (..)
import Json.Encode exposing (..)
import Task
import Process
import Time
import Array


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
    , description : String
    }


type alias Categories =
    List Category


type alias CategoryOption =
    { name : String
    , choices : CategoryOptionChoices
    }


type alias CategoryOptions =
    List CategoryOption


type alias CategoryOptionChoice =
    { name : String
    , selected : Bool
    }


type alias CategoryOptionChoices =
    List CategoryOptionChoice


type alias User =
    { first : String
    , last : String
    , location : Place
    , photo : String
    }


type alias Users =
    List User


type alias Recommendation =
    { interest : Interest
    , author : User
    , score : Int
    , highlights : String
    , photos : Photos
    , currentPhoto : Int
    }


type alias Recommendations =
    List Recommendation


type alias Interest =
    { name : String
    , description : String
    , place : Place
    , category : Category
    }


type alias Photo =
    { title : String
    , data : String
    , description : String
    }


type alias Photos =
    List Photo


type Step
    = Home
    | Categories
    | Recommendations
    | Interests


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
    , users : Users
    , recommendations : Recommendations
    , otherRecommendations : Recommendations
    , recommendation : Maybe Recommendation
    , showOptions : Bool
    , categoryOptions : CategoryOptions
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
    , users = allUsers
    , recommendations = allRecommendations
    , otherRecommendations = allRecommendations
    , recommendation = Nothing
    , showOptions = False
    , categoryOptions = allCategoryOptions
    }


allCategoryOptions : CategoryOptions
allCategoryOptions =
    [ { name = "Option 1"
      , choices =
            [ { name = "Value A", selected = False }
            , { name = "Value B", selected = True }
            , { name = "Value C", selected = False }
            ]
      }
    , { name = "Option 2"
      , choices =
            [ { name = "Value D", selected = False }
            , { name = "Value E", selected = True }
            , { name = "Value F", selected = False }
            ]
      }
    , { name = "Option 3"
      , choices =
            [ { name = "Value G", selected = False }
            , { name = "Value H", selected = True }
            , { name = "Value I", selected = False }
            ]
      }
    , { name = "Option 4"
      , choices =
            [ { name = "Value J", selected = False }
            , { name = "Value K", selected = True }
            , { name = "Value L", selected = False }
            ]
      }
    ]


allPlaces : Places
allPlaces =
    [ { country = "Indonesia", area = "Bali", location = "Denpasar" }
    , { country = "Indonesia", area = "Bali", location = "Jimbaran" }
    , { country = "Indonesia", area = "Bali", location = "Kuta" }
    , { country = "Indonesia", area = "Bali", location = "Negara" }
    , { country = "Indonesia", area = "Bali", location = "Singaraja" }
    , { country = "Indonesia", area = "Bali", location = "Ubud" }
    ]


accomodation : Category
accomodation =
    { name = "Accomodation", icon = "pe-7s-home", description = "Hotels, appartments, B&Bs..." }


allCategories : Categories
allCategories =
    [ accomodation
    , { name = "Transportation", icon = "pe-7s-car", description = "Local drivers, Buses, trains..." }
    , { name = "Food & Beverage", icon = "pe-7s-wine", description = "Restaurants, Bars, pubs, lounges..." }
    , { name = "Activities", icon = "pe-7s-photo", description = "Sightseeing, sports, guided tours..." }
    , { name = "Shopping", icon = "pe-7s-cart", description = "Goods, traditional clothing, local art..." }
    , { name = "Health", icon = "pe-7s-like", description = "Spas, well-being, relaxation..." }
    ]


kuta : Place
kuta =
    { country = "Indonesia", area = "Bali", location = "Kuta" }


marcos : User
marcos =
    { first = "Marcos"
    , last = "Modino"
    , location = kuta
    , photo = "data:image/jpeg;base64,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"
    }


allUsers : Users
allUsers =
    [ marcos ]


interest1 : Interest
interest1 =
    { name = "Interest1"
    , description = "Something really interesting"
    , place = kuta
    , category = accomodation
    }


somePhotos : Photos
somePhotos =
    [ { title = "Photo 1", description = "This is a photo", data = "images/indonesia1.jpg" }
    , { title = "Photo 2", description = "This is a photo", data = "images/indonesia2.jpg" }
    , { title = "Photo 3", description = "This is a photo", data = "images/indonesia3.jpg" }
    ]


allRecommendations : Recommendations
allRecommendations =
    [ { interest = interest1, author = marcos, score = 10, highlights = "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable.", photos = somePhotos, currentPhoto = 0 }
    , { interest = interest1, author = marcos, score = 10, highlights = "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable.", photos = somePhotos, currentPhoto = 0 }
    , { interest = interest1, author = marcos, score = 10, highlights = "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable.", photos = somePhotos, currentPhoto = 0 }
    , { interest = interest1, author = marcos, score = 10, highlights = "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable.", photos = somePhotos, currentPhoto = 0 }
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
    | ToggleOptions
    | ToggleChoice CategoryOption CategoryOptionChoice
    | SelectPlace Place
    | SelectCategory Category
    | SelectInterest Recommendation
    | Find
    | Recommend
    | BackHome
    | BackOne
    | WsMsg String
    | WsPing
    | NextSlide


slideShow : Cmd Msg
slideShow =
    Process.sleep (5 * Time.second)
        |> Task.perform (\_ -> NextSlide)


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

        Recommendations ->
            case ( model.mode, model.place, model.category ) of
                ( Just m, Just p, Just c ) ->
                    recommendationsView m p c model

                _ ->
                    errorView "Missing modei, place or category"

        Interests ->
            case ( model.mode, model.place, model.category, model.recommendation ) of
                ( Just m, Just p, Just c, Just r ) ->
                    interestView m p c r model

                _ ->
                    errorView "Missing modei, place, category or recommendation"


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


recommendationsView : Mode -> Place -> Category -> Model -> Html Msg
recommendationsView m p c model =
    div []
        [ headerSection model
        , recommendationsSection m p c model
        , footerSection model
        ]


interestView : Mode -> Place -> Category -> Recommendation -> Model -> Html Msg
interestView m p c r model =
    div []
        [ headerSection model
        , interestSection m p c r model.otherRecommendations
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
                    , h1 [ class "h1 w-full" ]
                        [ text (placeDescription place)
                        ]
                    ]
                ]
            , div [ class "row" ]
                (List.map categoryListItemView categories)
            , div [ class "row" ]
                [ div [ class "col-sm-12 text-center" ]
                    [ a [ class "btn btn-custom", onClick BackHome ]
                        [ text " Change destination"
                        ]
                    ]
                ]
            ]
        ]


categorySelectionTitle : Mode -> Html Msg
categorySelectionTitle mode =
    case mode of
        FindMode ->
            div []
                [ h3 [ class "title font-light" ]
                    [ text "Find" ]
                , h4 [ class "font-light w-full" ]
                    [ text "What are you looking for?" ]
                ]

        RecommendMode ->
            div []
                [ h3 [ class "title font-light" ]
                    [ text "Recommend" ]
                , h4 [ class "font-light w-full" ]
                    [ text "What would you like to recommend?" ]
                ]


categoryListItemView : Category -> Html Msg
categoryListItemView cat =
    div [ class "col-sm-4" ]
        [ div [ class "features-box" ]
            [ i [ class cat.icon ] []
            , h4 []
                [ a [ onClick (SelectCategory cat) ] [ text cat.name ]
                ]
            , p [ class "text-muted" ] [ text cat.description ]
            ]
        ]


recommendationsSection : Mode -> Place -> Category -> Model -> Html Msg
recommendationsSection mode place c model =
    section [ class "section bg-light", id "recommendations" ]
        [ div [ class "container" ]
            [ div [ class "row" ]
                [ div [ class "col-sm-12 text-center" ]
                    [ h3 [ class "title font-light" ]
                        [ text c.name
                        , text " in "
                        , text (placeDescription place)
                        ]
                    , h1 [ class "title" ] [ text "Top recommendations" ]
                    , p [ class "text-muted sub-title" ]
                        [ a [ class "btn btn-custom", onClick ToggleOptions ] [ text (toggleOptionsLabel model) ]
                        ]
                    ]
                ]
            , optionsView model
            , div [ class "row" ]
                (List.map recommendationView model.recommendations)
            ]
        ]


toggleOptionsLabel : Model -> String
toggleOptionsLabel model =
    case model.showOptions of
        True ->
            "Hide options"

        False ->
            "Show options"


optionsView : Model -> Html Msg
optionsView model =
    case model.showOptions of
        False ->
            div [ class "row" ] []

        True ->
            div [ class "row dark" ]
                [ div [ class "col-md-12" ]
                    [ div [ class "row" ]
                        []
                    , div [ class "row" ]
                        (List.map categoryOptionView model.categoryOptions)
                    ]
                ]


categoryOptionView : CategoryOption -> Html Msg
categoryOptionView option =
    article [ class "pricing-column col-lg-3 col-md-3" ]
        [ div [ class "inner-box" ]
            [ div [ class "plan-header text-center" ]
                [ h3 [ class "font-light" ] [ text option.name ] ]
            , ul [ class "plan-stats list-unstyled text-center" ]
                (List.map
                    (\c ->
                        li []
                            [ a [ onClick (ToggleChoice option c), class ("btn btn-inverse-fill " ++ (optionChoiceButtonStyle c)) ]
                                [ text c.name
                                ]
                            ]
                    )
                    option.choices
                )
            ]
        ]


optionChoiceButtonStyle : CategoryOptionChoice -> String
optionChoiceButtonStyle c =
    case c.selected of
        True ->
            "selected"

        False ->
            ""


newOptions : CategoryOptions -> CategoryOption -> CategoryOptionChoice -> CategoryOptions
newOptions options opt c =
    let
        newOpt =
            replaceChoice opt c
    in
        replaceOption options newOpt


replaceChoice : CategoryOption -> CategoryOptionChoice -> CategoryOption
replaceChoice opt c =
    { opt
        | choices =
            List.map
                (\c1 ->
                    case c1.name == c.name of
                        True ->
                            c

                        False ->
                            c1
                )
                opt.choices
    }


replaceOption : CategoryOptions -> CategoryOption -> CategoryOptions
replaceOption options opt =
    List.map
        (\o1 ->
            case o1.name == opt.name of
                True ->
                    opt

                False ->
                    o1
        )
        options


recommendationViewWithAuthor : String -> Recommendation -> Html Msg
recommendationViewWithAuthor style r =
    div [ class style ]
        [ div [ class "testimonial-description text-left" ]
            [ div [ class "testimonial-user-info user-info text-left" ]
                [ div [ class "user-score pull-right" ]
                    [ i [ class "pe-7s-star" ] []
                    , text (" " ++ (toString r.score))
                    ]
                , div [ class "testimonial-user-thumb user-thumb" ]
                    [ img [ src r.author.photo, alt "user-thumb" ]
                        []
                    ]
                , div [ class "testimonial-user-txt user-text" ]
                    [ label [ class "testimonial-user-name user-name" ]
                        [ text r.author.first ]
                    , p [ class "testimonial-user-position user-position text-muted" ]
                        [ text r.author.location.location ]
                    ]
                ]
            , p [ class "text-muted" ] [ text r.highlights ]
            , p [ class "photo-show" ]
                (recommendationPhotos
                    r
                )
            , p [ class "text-center" ]
                [ a [ class "btn btn-custom", onClick (SelectInterest r) ]
                    [ text "More"
                    ]
                ]
            ]
        ]


recommendationView : Recommendation -> Html Msg
recommendationView r =
    div [ class "col-md-4" ]
        [ div [ class "testimonial-description text-left" ]
            [ p [] [ text r.interest.name ]
            , p [] [ text r.interest.description ]
            , p [ class "text-muted" ] [ text r.highlights ]
            , p [ class "photo-show" ]
                (recommendationPhotos
                    r
                )
            , p [ class "text-center" ]
                [ a [ class "btn btn-custom", onClick (SelectInterest r) ]
                    [ text "Select this"
                    ]
                ]
            ]
        ]


recommendationPhotos : Recommendation -> List (Html Msg)
recommendationPhotos r =
    r.photos
        |> Array.fromList
        |> Array.toIndexedList
        |> List.reverse
        |> List.map
            (\( i, photo ) ->
                let
                    ( visibility, positioning ) =
                        ( photoVisibility i r.currentPhoto, photoPositioning i )
                in
                    img [ class ("photo-preview photo-preview-" ++ visibility ++ " photo-preview-" ++ positioning), src photo.data ] []
            )


photoVisibility : Int -> Int -> String
photoVisibility i1 i2 =
    case i1 == i2 of
        True ->
            "shown"

        False ->
            "hidden"


photoPositioning : Int -> String
photoPositioning i =
    case i of
        0 ->
            "relative"

        _ ->
            "absolute"


interestSection : Mode -> Place -> Category -> Recommendation -> Recommendations -> Html Msg
interestSection m place cat r other =
    section [ class "section bg-light", id "interest" ]
        [ div [ class "container" ]
            [ div [ class "row" ]
                [ div [ class "col-sm-12 text-center" ]
                    [ h3 [ class "title font-light" ]
                        [ text cat.name
                        , text " in "
                        , text (placeDescription place)
                        ]
                    , h1 [ class "title" ] [ text r.interest.name ]
                    , p [ class "text-muted sub-title" ]
                        [ text r.interest.description
                        ]
                    ]
                ]
            , div [ class "row" ]
                [ recommendationViewWithAuthor "col-md-12 text-center" r ]
            , div [ class "row" ]
                (List.map (recommendationViewWithAuthor "col-md-4") other)
            , div [ class "row" ]
                [ div [ class "col-md-12 text-center nav-buttons" ]
                    [ a [ class "btn btn-custom", onClick BackOne ]
                        [ text "Go Back"
                        ]
                    , a [ class "btn btn-custom", onClick BackHome ]
                        [ text "Change destination"
                        ]
                    ]
                ]
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
                            " enables travellers and local citizens to share their recommendations about their past travel experiences and local favourite spots"
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
                        , h4 [] [ text "Sell your experience" ]
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

        SelectCategory c ->
            ( { model | step = Recommendations, category = Just c }, slideShow )

        ToggleOptions ->
            ( { model | showOptions = not (model.showOptions) }, slideShow )

        ToggleChoice opt c ->
            ( { model | categoryOptions = (newOptions model.categoryOptions opt { c | selected = not (c.selected) }) }, slideShow )

        SelectInterest r ->
            ( { model | step = Interests, recommendation = Just r }, slideShow )

        BackHome ->
            ( { model | step = Home, mode = Nothing, keywords = "", place = Nothing }, Cmd.none )

        BackOne ->
            ( { model | step = Recommendations, recommendation = Nothing }, slideShow )

        Find ->
            ( { model | step = Categories, mode = Just FindMode }, Cmd.none )

        Recommend ->
            ( { model | step = Categories, mode = Just RecommendMode }, Cmd.none )

        NextSlide ->
            case model.step of
                Recommendations ->
                    ( { model | recommendations = (List.map showNextPhoto model.recommendations) }, slideShow )

                Interests ->
                    ( { model
                        | otherRecommendations = (List.map showNextPhoto model.otherRecommendations)
                        , recommendation = (maybeShowNextPhoto model.recommendation)
                      }
                    , slideShow
                    )

                _ ->
                    ( model, Cmd.none )

        WsMsg str ->
            ( model, Cmd.none )

        WsPing ->
            ( model, WebSocket.send (wsUrl model.flags) (encodeText "Hello there") )


maybeShowNextPhoto : Maybe Recommendation -> Maybe Recommendation
maybeShowNextPhoto rec =
    case rec of
        Nothing ->
            Nothing

        Just r ->
            r
                |> showNextPhoto
                |> Just


showNextPhoto : Recommendation -> Recommendation
showNextPhoto r =
    let
        ( i, max ) =
            ( r.currentPhoto, (List.length r.photos) - 1 )
    in
        case i == max of
            True ->
                { r | currentPhoto = 0 }

            False ->
                { r | currentPhoto = i + 1 }


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
