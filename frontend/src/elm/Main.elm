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
import Date


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
    , aspects : RecommendationAspects
    , isNew : Bool
    }


type alias Recommendations =
    List Recommendation


type alias RecommendationAspect =
    { name : String
    , text : String
    , photos : Photos
    , currentPhoto : Int
    }


type alias RecommendationAspects =
    List RecommendationAspect


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
    | SingleRecommendation
    | NewRecommendation
    | RecommendationSummary
    | Error


type Mode
    = FindMode
    | RecommendMode


type alias Conversation =
    List Message


type alias Message =
    { from : User
    , to : User
    , content : String
    , status : MessageStatus
    }


type MessageStatus
    = New
    | Seen
    | Sending


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
    , chat : Bool
    , conversation : Maybe Conversation
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
    , chat = False
    , conversation = Just sampleConversation
    }


sampleConversation : Conversation
sampleConversation =
    [ { from = marcos, to = pedro, content = "Hi there!", status = Seen }
    , { from = pedro, to = marcos, content = "Hello ;)", status = Seen }
    ]


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


pedro : User
pedro =
    { first = "Pedro"
    , last = "Guti"
    , location = kuta
    , photo = marcos.photo
    }


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


allAspects : RecommendationAspects
allAspects =
    [ { name = "Room", text = "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable.", photos = somePhotos, currentPhoto = 0 }
    , { name = "Service", text = "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable.", photos = somePhotos, currentPhoto = 0 }
    , { name = "Food", text = "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable.", photos = somePhotos, currentPhoto = 0 }
    , { name = "Amenities", text = "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable.", photos = somePhotos, currentPhoto = 0 }
    ]


allRecommendations : Recommendations
allRecommendations =
    [ { isNew = False, interest = interest1, author = marcos, score = 10, highlights = "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable.", photos = somePhotos, currentPhoto = 0, aspects = allAspects }
    , { isNew = False, interest = interest1, author = marcos, score = 10, highlights = "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable.", photos = somePhotos, currentPhoto = 0, aspects = allAspects }
    , { isNew = False, interest = interest1, author = marcos, score = 10, highlights = "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable.", photos = somePhotos, currentPhoto = 0, aspects = allAspects }
    , { isNew = False, interest = interest1, author = marcos, score = 10, highlights = "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable.", photos = somePhotos, currentPhoto = 0, aspects = allAspects }
    ]


newRecommendation : Place -> Category -> Recommendation
newRecommendation place cat =
    { isNew = True, interest = (newInterest place cat), author = marcos, score = 0, highlights = "", photos = [], currentPhoto = 0, aspects = allAspects }


newInterest : Place -> Category -> Interest
newInterest place cat =
    { name = "", description = "", category = cat, place = place }


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
    | ToggleChat
    | ToggleChoice CategoryOption CategoryOptionChoice
    | SelectPlace Place
    | SelectCategory Category
    | SelectInterest Recommendation
    | SelectRecommendation Recommendation
    | RecommendNew
    | SaveRecommendation Recommendation
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
        Error ->
            errorView "Error in update"

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
                    errorView "Missing mode, place or category"

        Interests ->
            case ( model.mode, model.place, model.category, model.recommendation ) of
                ( Just m, Just p, Just c, Just r ) ->
                    interestView m p c r model

                _ ->
                    errorView "Missing modei, place, category or recommendation"

        SingleRecommendation ->
            case ( model.mode, model.place, model.category, model.recommendation ) of
                ( Just m, Just p, Just c, Just r ) ->
                    singleRecommendationView m p c r model

                _ ->
                    errorView "Missing mode, place, category or recommendation"

        NewRecommendation ->
            case ( model.mode, model.place, model.category, model.recommendation ) of
                ( Just m, Just p, Just c, Just r ) ->
                    newRecommendationView m p c r model

                _ ->
                    errorView "Missing mode, place, category or recommendation"

        RecommendationSummary ->
            case ( model.mode, model.place, model.category, model.recommendation ) of
                ( Just m, Just p, Just c, Just r ) ->
                    recommendationSummaryView m p c r model

                _ ->
                    errorView "Missing mode, place, category or recommendation"


layoutView : Model -> List (Html Msg) -> Html Msg
layoutView model contents =
    case model.chat of
        False ->
            div [ class "row" ]
                [ div [ class "col-md-12" ] contents ]

        True ->
            div [ class "row" ]
                [ div [ class "col-md-9" ]
                    contents
                , div [ class "col-md-3 sidebar" ]
                    [ chatSection model ]
                ]


homeView : Model -> Html Msg
homeView model =
    div []
        [ layoutView model
            [ headerSection model
            , startSection model
            , featuresSection model
            , footerSection model
            ]
        ]


categoriesView : Mode -> Place -> Model -> Html Msg
categoriesView m p model =
    div []
        [ layoutView model
            [ headerSection model
            , categoriesSection m p model.categories
            , footerSection model
            ]
        ]


recommendationsView : Mode -> Place -> Category -> Model -> Html Msg
recommendationsView m p c model =
    div []
        [ layoutView model
            [ headerSection model
            , recommendationsSection m p c model
            , footerSection model
            ]
        ]


interestView : Mode -> Place -> Category -> Recommendation -> Model -> Html Msg
interestView m p c r model =
    div []
        [ layoutView model
            [ headerSection model
            , interestSection m p c r model.otherRecommendations
            , footerSection model
            ]
        ]


singleRecommendationView : Mode -> Place -> Category -> Recommendation -> Model -> Html Msg
singleRecommendationView m p c r model =
    div []
        [ layoutView model
            [ headerSection model
            , singleRecommendationSection m p c r model
            , footerSection model
            ]
        ]


newRecommendationView : Mode -> Place -> Category -> Recommendation -> Model -> Html Msg
newRecommendationView m p c r model =
    div []
        [ layoutView model
            [ headerSection model
            , newRecommendationSection m p c r model
            , footerSection model
            ]
        ]


recommendationSummaryView : Mode -> Place -> Category -> Recommendation -> Model -> Html Msg
recommendationSummaryView m p c r model =
    div []
        [ layoutView model
            [ headerSection model
            , recommendationSummarySection m p c r model
            , footerSection model
            ]
        ]


errorView : String -> Html Msg
errorView msg =
    div []
        [ text ("Error: " ++ msg)
        ]


headerSection : Model -> Html Msg
headerSection model =
    div [ id "sticky-nav-sticky-wrapper", class "" ]
        [ div [ role "navigation", id "sticky-nav" ]
            [ div [ class "my-container" ]
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
                        [ li [] [ a [ class "navbar-lnk" ] [ text "Login" ] ]
                        , li [] [ a [ class "btn btn-white-fill navbar-btn" ] [ text "Join now" ] ]
                        ]
                    ]
                ]
            ]
        ]


chatSection : Model -> Html Msg
chatSection model =
    case model.chat of
        False ->
            div [] []

        True ->
            case model.conversation of
                Nothing ->
                    div [ id "chat" ] []

                Just messages ->
                    div [ id "chat" ]
                        [ div [ class "row" ]
                            [ div [ class "col-md-12 text-center" ]
                                [ a [ onClick ToggleChat, class "btn btn-inverse-fill" ]
                                    [ text "Close chat" ]
                                ]
                            ]
                        , div [ class "row" ]
                            [ div [ class "col-md-12 messages" ]
                                (List.map chatMessageView messages)
                            ]
                        ]


chatMessageView : Message -> Html Msg
chatMessageView message =
    div [ class "message" ]
        [ div [ class "testimonial-user-thumb user-thumb" ]
            [ img [ src message.from.photo, alt "user-thumb" ]
                []
            ]
        , div [ class "testimonial-user-txt user-text" ]
            [ label [ class "testimonial-user-name user-name" ]
                [ text message.from.first ]
            , p [ class "testimonial-user-position user-position text-muted" ]
                [ text message.content ]
            ]
        ]


startSection : Model -> Html Msg
startSection model =
    section [ class "bg-custom home", id "home" ]
        [ div [ class "home-sm" ]
            [ div [ class "my-container" ]
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
        [ div [ class "my-container" ]
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
        [ div [ class "my-container" ]
            [ div [ class "row" ]
                [ div [ class "col-sm-12 text-center" ]
                    [ h1 [ class "" ] [ text "Top recommendations" ]
                    , h4 [ class "font-light" ]
                        [ text c.name
                        , text " in "
                        , text (placeDescription place)
                        ]
                    , p [ class "text-muted sub-title" ]
                        [ a [ class "btn btn-custom", onClick ToggleOptions ] [ text (toggleOptionsLabel model) ]
                        , addRecommendationView model
                        ]
                    ]
                ]
            , optionsView model
            , div [ class "row" ]
                (List.map recommendationView model.recommendations)
            , div [ class "row" ]
                [ div [ class "col-md-12 text-center nav-buttons" ]
                    [ a [ class "btn btn-custom", onClick BackOne ]
                        [ text "Go back"
                        ]
                    , a [ class "btn btn-custom", onClick BackHome ]
                        [ text "Change destination"
                        ]
                    ]
                ]
            ]
        ]


addRecommendationView : Model -> Html Msg
addRecommendationView model =
    case model.mode of
        Just RecommendMode ->
            a [ class "btn btn-custom", onClick RecommendNew ]
                [ text "Recommend something new" ]

        _ ->
            text ""


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
            optionsPanel "col-lg-3 col-md-3" model


optionsPanel : String -> Model -> Html Msg
optionsPanel style model =
    div [ class "row dark" ]
        [ div [ class "col-md-12" ]
            [ div [ class "row" ]
                [ div [ class "col-md-12" ]
                    [ h3 [] [ text "Options" ] ]
                ]
            , div [ class "row" ]
                (List.map (categoryOptionView style) model.categoryOptions)
            ]
        ]


categoryOptionView : String -> CategoryOption -> Html Msg
categoryOptionView style option =
    article [ class ("pricing-column " ++ style) ]
        [ div [ class "inner-box" ]
            [ div [ class "plan-header text-center" ]
                [ h4 [ class "font-light" ] [ text option.name ] ]
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
                (photoShow r.currentPhoto r.photos)
            , p [ class "text-center" ]
                [ a [ class "btn btn-custom", onClick (SelectRecommendation r) ]
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
                (photoShow r.currentPhoto r.photos)
            , p [ class "text-center" ]
                [ a [ class "btn btn-custom", onClick (SelectInterest r) ]
                    [ text "Select this"
                    ]
                ]
            ]
        ]


photoShow : Int -> Photos -> List (Html Msg)
photoShow currentPhoto photos =
    photos
        |> Array.fromList
        |> Array.toIndexedList
        |> List.reverse
        |> List.map
            (\( i, photo ) ->
                let
                    ( visibility, positioning ) =
                        ( photoVisibility i currentPhoto, photoPositioning i )
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
        [ div [ class "my-container" ]
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


singleRecommendationSection : Mode -> Place -> Category -> Recommendation -> Model -> Html Msg
singleRecommendationSection m place c r model =
    section [ class "section bg-light", id "single-recommendation" ]
        [ div [ class "my-container" ]
            [ div [ class "row" ]
                [ div [ class "col-sm-8" ]
                    (([ div [ class "row" ]
                            [ div [ class "col-sm-12" ]
                                [ h1 [ class "h1" ]
                                    [ text r.interest.name ]
                                , h3 [ class "title" ]
                                    [ text r.interest.description ]
                                , h4 [ class "font-light" ]
                                    [ text c.name
                                    , text " in "
                                    , text (placeDescription place)
                                    ]
                                ]
                            ]
                      , div [ class "row" ]
                            [ div [ class "col-sm-12" ]
                                [ text r.highlights ]
                            ]
                      ]
                     )
                        ++ (List.map recommendationAspectView r.aspects)
                    )
                , div [ class "col-sm-4 text-center" ]
                    [ div [ class "testimonial-user-thumb user-thumb full" ]
                        [ img [ src r.author.photo, alt "user-thumb" ]
                            []
                        ]
                    , div [ class "testimonial-user-txt margin-top-10" ]
                        [ label [ class "testimonial-user-name user-name" ]
                            [ text r.author.first ]
                        , p [ class "testimonial-user-position user-position text-muted" ]
                            [ text r.author.location.location ]
                        ]
                    , div [ class "user-actions" ]
                        [ a [ class "btn btn-sm btn-custom" ]
                            [ text "Follow"
                            ]
                        , a [ class "btn btn-sm btn-custom", onClick ToggleChat ]
                            [ text "Chat"
                            ]
                        ]
                    ]
                , div [ class "row" ]
                    [ div [ class "col-md-12 text-center nav-buttons" ]
                        [ a [ class "btn btn-custom", onClick BackOne ]
                            [ text "Go Back"
                            ]
                        ]
                    ]
                ]
            ]
        ]


newRecommendationSection : Mode -> Place -> Category -> Recommendation -> Model -> Html Msg
newRecommendationSection m place c r model =
    section [ class "section bg-light", id "new-recommendation" ]
        [ div [ class "my-container" ]
            (([ div [ class "row" ]
                    [ div [ class "col-sm-12 text-center" ]
                        [ h1 [ class "" ]
                            [ text "New Recommendation" ]
                        , h4 [ class "font-light" ]
                            [ text c.name
                            , text " in "
                            , text (placeDescription place)
                            ]
                        ]
                    ]
              , (newRecommendationNameSection r)
              , div [ class "row margin-top-30" ]
                    [ div [ class "col-md-12 intro-form intro-form-2" ]
                        [ h3 [ class "font-light" ]
                            [ text "Highlights " ]
                        , div [ class "form-group" ]
                            [ textarea [ rows 5, class "form-control", placeholder "Please tell us what you liked the most" ] [] ]
                        ]
                    ]
              , div [ class "row margin-top-30" ]
                    [ div [ class "col-md-12" ]
                        [ optionsPanel "col-lg-3 col-md-3" model ]
                    ]
              ]
             )
                ++ (List.map aspectFormView r.aspects)
                ++ [ div [ class "row margin-top-30" ]
                        [ div [ class "col-md-12 text-center" ]
                            [ a [ onClick BackOne, class "btn btn-custom" ]
                                [ text "Cancel" ]
                            , a [ onClick (SaveRecommendation r), class "btn btn-custom" ]
                                [ text "Save" ]
                            ]
                        ]
                   ]
            )
        ]


recommendationSummarySection : Mode -> Place -> Category -> Recommendation -> Model -> Html Msg
recommendationSummarySection m place c r model =
    section [ class "section bg-light", id "recommendation-summary" ]
        [ div [ class "my-container" ]
            [ div [ class "row" ]
                [ div [ class "col-sm-12 text-center" ]
                    [ h1 [ style [ ( "font-size", "48px" ) ] ]
                        [ i [ class "pe-7s-smile" ] []
                        ]
                    , h4 [ class "font-light" ]
                        [ text "Thank you for your recommendation about "
                        , span []
                            [ text r.interest.name
                            ]
                        ]
                    , h4 [ class "font-light" ]
                        [ text "Our team will revise your recommendation and we will publish it"
                        , br [] []
                        , text "once we have confirmed it complies with "
                        , span [] [ text "weeKonekt" ]
                        , text "'s guidelines"
                        ]
                    ]
                ]
            , div [ class "row margin-top-30" ]
                [ div [ class "col-sm-12 text-center" ]
                    [ h4 []
                        [ text "Would you accept to be koneKted by fellow travellers regarding this recommendation?"
                        ]
                    , p []
                        [ a [ class "btn btn-custom", onClick BackHome ] [ text "No" ]
                        , a [ class "btn btn-custom", onClick BackHome ] [ text "Yes" ]
                        ]
                    ]
                ]
            ]
        ]


newRecommendationNameSection : Recommendation -> Html Msg
newRecommendationNameSection r =
    case r.isNew of
        False ->
            div [ class "row margin-top-30" ]
                [ div [ class "col-md-12" ]
                    [ h1 [ class "font-light" ]
                        [ text r.interest.name ]
                    , h4 [ class "font-light" ]
                        [ text r.interest.description ]
                    ]
                ]

        True ->
            div [ class "row margin-top-30" ]
                [ div [ class "col-md-12 intro-form intro-form-2" ]
                    [ h3 [ class "font-light" ]
                        [ text "What would you like to recommend?" ]
                    , div [ class "form-group" ]
                        [ input [ type_ "text", class "form-control", placeholder "Enter the name of what you would like to recommend" ] [] ]
                    ]
                ]


aspectFormView : RecommendationAspect -> Html Msg
aspectFormView aspect =
    div [ class "row margin-top-30" ]
        [ div [ class "col-md-12 intro-form intro-form-2" ]
            [ h3 [ class "font-light" ]
                [ text aspect.name ]
            , div [ class "form-group" ]
                [ textarea [ rows 5, class "form-control", placeholder "Please tell us what you liked the most" ] [] ]
            ]
        ]


recommendationAspectView : RecommendationAspect -> Html Msg
recommendationAspectView aspect =
    div [ class "row" ]
        [ div [ class "col-md-12" ]
            [ div [ class "testimonial-description text-left" ]
                [ h3 [] [ text aspect.name ]
                , p [] [ text aspect.text ]
                , p [ class "photo-show" ]
                    (photoShow aspect.currentPhoto aspect.photos)
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
        [ div [ class "my-container" ]
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
        [ div [ class "my-container" ]
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

        ToggleChat ->
            ( { model | chat = not (model.chat) }, Cmd.none )

        ToggleChoice opt c ->
            ( { model | categoryOptions = (newOptions model.categoryOptions opt { c | selected = not (c.selected) }) }, slideShow )

        SelectInterest r ->
            case model.mode of
                Just FindMode ->
                    ( { model | step = Interests, recommendation = Just r }, slideShow )

                Just RecommendMode ->
                    ( { model | step = NewRecommendation, recommendation = Just r }, Cmd.none )

                _ ->
                    ( { model | step = Error }, Cmd.none )

        SelectRecommendation r ->
            ( { model | step = SingleRecommendation, recommendation = Just r }, slideShow )

        RecommendNew ->
            case ( model.place, model.category ) of
                ( Just p, Just c ) ->
                    ( { model | step = NewRecommendation, recommendation = Just (newRecommendation p c) }, Cmd.none )

                _ ->
                    ( { model | step = Error }, Cmd.none )

        SaveRecommendation r ->
            ( { model | step = RecommendationSummary }, Cmd.none )

        BackHome ->
            ( { model | step = Home, mode = Nothing, keywords = "", place = Nothing, category = Nothing, recommendation = Nothing }, Cmd.none )

        BackOne ->
            case model.step of
                Interests ->
                    ( { model | step = Recommendations, recommendation = Nothing }, slideShow )

                Recommendations ->
                    ( { model | step = Categories, category = Nothing }, Cmd.none )

                SingleRecommendation ->
                    ( { model | step = Interests }, slideShow )

                NewRecommendation ->
                    ( { model | step = Recommendations, recommendation = Nothing }, slideShow )

                _ ->
                    ( model, Cmd.none )

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

                SingleRecommendation ->
                    ( { model
                        | recommendation = (maybeShowNextAspectPhoto model.recommendation)
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
    { r | currentPhoto = (nextPhoto r.currentPhoto r.photos) }


maybeShowNextAspectPhoto : Maybe Recommendation -> Maybe Recommendation
maybeShowNextAspectPhoto rec =
    case rec of
        Nothing ->
            Nothing

        Just r ->
            r
                |> showNextAspectPhoto
                |> Just


showNextAspectPhoto : Recommendation -> Recommendation
showNextAspectPhoto r =
    { r
        | aspects =
            (List.map
                (\a ->
                    { a | currentPhoto = (nextPhoto a.currentPhoto a.photos) }
                )
                r.aspects
            )
    }


nextPhoto : Int -> Photos -> Int
nextPhoto current photos =
    case current == ((List.length photos) - 1) of
        True ->
            0

        False ->
            current + 1


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
