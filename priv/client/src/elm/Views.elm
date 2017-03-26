module Views exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Messages exposing (..)
import Models exposing (..)
import Helpers exposing (..)
import Set exposing (..)


type alias MenuItem =
    { msg : Msg
    , label : String
    , roles : Roles
    , active : Bool
    }


type alias MenuItems =
    List MenuItem


view : Model -> Html Msg
view model =
    case
        model.page
    of
        ErrorPage ->
            errorPageView
                model

        CheckingSessionPageForSessionFlowInStateChecking ->
            checkingSessionPageForSessionFlowInStateCheckingView
                model

        ConnectingPageForConnectionFlowInStateChecking ->
            connectingPageForConnectionFlowInStateCheckingView
                model

        UserLandingPageForWelcomeFlowInStateUser ->
            userLandingPageForWelcomeFlowInStateUserView
                model

        LocationsSearchResultsForSelectLocationFlowInStateUnselected ->
            locationsSearchResultsForSelectLocationFlowInStateUnselectedView
                model

        ActionSelectionPageForChooseActionFlowInStateUnselected ->
            actionSelectionPageForChooseActionFlowInStateUnselectedView
                model

        SearchingPageForSearchCategoryFlowInStateSearching ->
            searchingPageForSearchCategoryFlowInStateSearchingView
                model

        CategoriesSearchResultsPageForSearchCategoryFlowInStateFound ->
            categoriesSearchResultsPageForSearchCategoryFlowInStateFoundView
                model

        CategoryOptionsPageForSearchCategoryOptionsFlowInStateSuccess ->
            categoryOptionsPageForSearchCategoryOptionsFlowInStateSuccessView
                model

        SearchingPageForSearchCategoryOptionsFlowInStateSearching ->
            searchingPageForSearchCategoryOptionsFlowInStateSearchingView
                model

        TopRecommendationsForSearchTopRecommendationsFlowInStateFound ->
            topRecommendationsForSearchTopRecommendationsFlowInStateFoundView
                model

        SearchingPageForSearchTopRecommendationsFlowInStateSearching ->
            searchingPageForSearchTopRecommendationsFlowInStateSearchingView
                model

        AllRecommendationsForSearchRelatedRecommendationsFlowInStateFound ->
            allRecommendationsForSearchRelatedRecommendationsFlowInStateFoundView
                model

        SearchingPageForSearchRelatedRecommendationsFlowInStateSearching ->
            searchingPageForSearchRelatedRecommendationsFlowInStateSearchingView
                model

        LoginPageForLoginFlowInStateReady ->
            loginPageForLoginFlowInStateReadyView
                model

        RegisterPageForRegisterFlowInStateReady ->
            registerPageForRegisterFlowInStateReadyView
                model

        RecommendationDetailForShowRecommendationDetailFlowInStateFound ->
            recommendationDetailForShowRecommendationDetailFlowInStateFoundView
                model

        SearchingPageForSearchLocationFlowInStateSearching ->
            searchingPageForSearchLocationFlowInStateSearchingView
                model

        LocationSearchPageForSearchLocationFlowInStateReady ->
            locationSearchPageForSearchLocationFlowInStateReadyView
                model


errorSection : String -> String -> Html Msg
errorSection summary description =
    div
        []
        [ h1
            []
            [ text
                summary
            ]
        , p
            []
            [ text
                description
            ]
        ]


errorPageView : Model -> Html Msg
errorPageView model =
    case
        model.error
    of
        Nothing ->
            errorSection
                "Unknown Error"
                "Some weird error happened! Contact Gutierrez"

        Just e ->
            errorSection
                e.summary
                e.description


emptyListView : Html Msg
emptyListView =
    ul
        [ class "list-unstyled"
        ]
        [ li
            []
            [ text
                "Nothing to show"
            ]
        ]


categoryOptionsFormView : CategoryOptions -> Model -> Html Msg
categoryOptionsFormView co model =
    div
        [ class "category-options-form"
        ]
        (case
            model.categoryOptions
         of
            Nothing ->
                []

            Just l ->
                (List.map
                    (\co ->
                        categoryOptionFormItemView
                            co
                            model
                    )
                    l
                )
        )


categoryOptionFormItemView : CategoryOption -> Model -> Html Msg
categoryOptionFormItemView co model =
    div
        [ class "category-option-form-item"
        ]
        [ (iconHtml
            co.icon
          )
        , span
            []
            [ text
                co.aspect
            ]
        , div
            [ class "btn-group"
            , type_ "button"
            , attribute "role"
                "group"
            ]
            (List.map
                (\v ->
                    button
                        [ class
                            ("btn btn-default"
                                ++ (ifSameIds
                                        v.id
                                        co.choices.selected
                                        "active"
                                   )
                            )
                        , onClick
                            (OnCategoryOptionNewChoices co.id v.id)
                        ]
                        [ text
                            v.label
                        ]
                )
                co.choices.values
            )
        ]


credentialsFormView : Credentials -> Model -> Html Msg
credentialsFormView c model =
    div
        [ class "credentials-form"
        ]
        [ div
            [ class "form-group"
            ]
            [ input
                [ id "username"
                , class "form-control"
                , type_ "text"
                , placeholder "Please type in something"
                , onInput
                    (OnCredentialsNewUsername c.id)
                ]
                []
            ]
        , p
            []
            [ text
                "property type not implemented yet: Secured Text"
            ]
        , p
            []
            [ text
                "property type not implemented yet: Boolean"
            ]
        ]


locationSearchFormView : LocationSearch -> Model -> Html Msg
locationSearchFormView ls model =
    div
        [ class "location-search-form"
        ]
        [ div
            [ class "form-group"
            ]
            [ input
                [ id "keywords"
                , class "form-control"
                , type_ "text"
                , placeholder "Please type in something"
                , onInput
                    (OnLocationSearchNewKeywords ls.id)
                ]
                []
            ]
        ]


locationsListItemViewInFlowSelectLocation : Location -> Html Msg
locationsListItemViewInFlowSelectLocation l =
    li
        [ class "location-list-item"
        ]
        [ div
            [ class "icon"
            ]
            [ (iconHtml
                l.icon
              )
            ]
        , div
            [ class "area"
            ]
            [ (textHtml
                l.area
              )
            ]
        , div
            [ class "region"
            ]
            [ (textHtml
                l.region
              )
            ]
        , div
            [ class "country"
            ]
            [ (textHtml
                l.country
              )
            ]
        , div
            [ class "select"
            ]
            [ button
                [ class "btn btn-default btn-xs"
                , onClick
                    (LocationSelectedInFlowSelectLocationInStateUnselected l.id)
                ]
                [ text
                    "Select this"
                ]
            ]
        ]


categoriesListItemViewInFlowSearchCategory : Category -> Html Msg
categoriesListItemViewInFlowSearchCategory c =
    li
        [ class "category-list-item"
        ]
        [ div
            [ class "icon"
            ]
            [ (iconHtml
                c.icon
              )
            ]
        , div
            [ class "name"
            ]
            [ (textHtml
                c.name
              )
            ]
        , div
            [ class "description"
            ]
            [ (textHtml
                c.description
              )
            ]
        , div
            [ class "select"
            ]
            [ button
                [ class "btn btn-default btn-xs"
                , onClick
                    (CategorySelectedInFlowSearchCategoryInStateFound c.id)
                ]
                [ text
                    "Select this"
                ]
            ]
        ]


recommendationSearchResultsListItemViewInFlowSearchTopRecommendations : RecommendationSummary -> Html Msg
recommendationSearchResultsListItemViewInFlowSearchTopRecommendations rs =
    li
        [ class "recommendation-summary-list-item"
        ]
        [ div
            [ class "summary"
            ]
            [ (textHtml
                rs.summary
              )
            ]
        , div
            [ class "highlights"
            ]
            [ (paragraphsHtml
                rs.highlights
              )
            ]
        , div
            [ class "select"
            ]
            [ button
                [ class "btn btn-default btn-xs"
                , onClick
                    (RecommendationSummarySelectedInFlowSearchTopRecommendationsInStateFound rs.id)
                ]
                [ text
                    "Show more"
                ]
            ]
        ]


recommendationSearchResultsListItemViewInFlowSearchRelatedRecommendations : RecommendationSummary -> Html Msg
recommendationSearchResultsListItemViewInFlowSearchRelatedRecommendations rs =
    li
        [ class "recommendation-summary-list-item"
        ]
        [ div
            [ class "summary"
            ]
            [ (textHtml
                rs.summary
              )
            ]
        , div
            [ class "highlights"
            ]
            [ (paragraphsHtml
                rs.highlights
              )
            ]
        , div
            [ class "select"
            ]
            [ button
                [ class "btn btn-default btn-xs"
                , onClick
                    (RecommendationSummarySelectedInFlowSearchRelatedRecommendationsInStateFound rs.id)
                ]
                [ text
                    "Show more ..."
                ]
            ]
        ]


recommendationPhotosListItemViewInFlowShowRecommendationDetail : RecommendationPhoto -> Html Msg
recommendationPhotosListItemViewInFlowShowRecommendationDetail rp =
    li
        [ class "recommendation-photo-list-item"
        ]
        [ div
            [ class "description"
            ]
            [ (textHtml
                rp.description
              )
            ]
        , div
            [ class "select"
            ]
            [ button
                [ class "btn btn-default btn-xs"
                , onClick
                    (RecommendationPhotoSelectedInFlowShowRecommendationDetailInStateFound rp.id)
                ]
                [ text
                    "The user selected a recommendation aspect"
                ]
            ]
        ]


checkingSessionPageForSessionFlowInStateCheckingView : Model -> Html Msg
checkingSessionPageForSessionFlowInStateCheckingView model =
    div
        []
        [ div
            [ class
                "container"
            ]
            [ div
                [ class
                    "col-md-12"
                ]
                [ div
                    [ class
                        "row"
                    ]
                    [ h1
                        []
                        [ text
                            "Checking your session"
                        ]
                    , h3
                        []
                        [ text
                            "Looking for an existing session on the server"
                        ]
                    ]
                ]
            ]
        ]


connectingPageForConnectionFlowInStateCheckingView : Model -> Html Msg
connectingPageForConnectionFlowInStateCheckingView model =
    div
        []
        [ div
            [ class
                "container"
            ]
            [ div
                [ class
                    "row"
                ]
                [ div
                    [ class
                        "col-md-12"
                    ]
                    [ h1
                        []
                        [ text
                            "Connecting"
                        ]
                    , h3
                        []
                        [ text
                            "Checking connectivity with the server"
                        ]
                    ]
                ]
            ]
        ]


userLandingPageForWelcomeFlowInStateUserView : Model -> Html Msg
userLandingPageForWelcomeFlowInStateUserView model =
    div
        []
        [ div
            [ class
                "container"
            ]
            [ div
                [ class
                    "row"
                ]
                [ div
                    [ class
                        "col-md-12"
                    ]
                    [ h1
                        []
                        [ text
                            "Visitor Landing Page Section1"
                        ]
                    , h3
                        []
                        [ text
                            "Plopfsafs"
                        ]
                    , case
                        model.info
                      of
                        Nothing ->
                            errorSection
                                "Unable to render summary view"
                                "Expecting a instance of type Info but nothing was found"

                        Just i ->
                            div
                                [ class "info-summary"
                                ]
                                [ div
                                    [ class "name"
                                    ]
                                    [ (textHtml
                                        i.name
                                      )
                                    ]
                                , div
                                    [ class "version"
                                    ]
                                    [ (textHtml
                                        i.version
                                      )
                                    ]
                                , div
                                    [ class "database"
                                    ]
                                    [ (booleanHtml
                                        i.database
                                      )
                                    ]
                                ]
                    ]
                ]
            , div
                [ class "row actions"
                ]
                [ div
                    [ class "col-md-12"
                    ]
                    []
                ]
            ]
        ]


locationsSearchResultsForSelectLocationFlowInStateUnselectedView : Model -> Html Msg
locationsSearchResultsForSelectLocationFlowInStateUnselectedView model =
    div
        []
        [ mainMenu
            model
        , div
            [ class
                "container"
            ]
            [ div
                [ class
                    "col-md-12"
                ]
                [ div
                    [ class
                        "row"
                    ]
                    [ h1
                        []
                        [ text
                            "Locations"
                        ]
                    , h3
                        []
                        [ text
                            ""
                        ]
                    , div
                        []
                        [ case
                            model.locations
                          of
                            Nothing ->
                                emptyListView

                            Just l ->
                                case
                                    List.isEmpty
                                        l
                                of
                                    True ->
                                        emptyListView

                                    False ->
                                        ul
                                            [ class "locations-list"
                                            ]
                                            (List.map
                                                locationsListItemViewInFlowSelectLocation
                                                l
                                            )
                        ]
                    ]
                ]
            , div
                [ class "row actions"
                ]
                [ div
                    [ class "col-md-12"
                    ]
                    [ button
                        [ type_ "submit"
                        , class "btn btn-primary"
                        , onClick
                            OnSelectLocationSearchAgain
                        ]
                        [ text
                            "Search again"
                        ]
                    ]
                ]
            ]
        ]


actionSelectionPageForChooseActionFlowInStateUnselectedView : Model -> Html Msg
actionSelectionPageForChooseActionFlowInStateUnselectedView model =
    div
        []
        [ mainMenu
            model
        , div
            [ class
                "container"
            ]
            [ div
                [ class
                    "col-md-12"
                ]
                [ div
                    [ class
                        "row"
                    ]
                    [ h1
                        []
                        [ text
                            "What do you want to do?"
                        ]
                    , h3
                        []
                        [ text
                            "Please select whether you want to look for existing recommendations, or create a new one"
                        ]
                    , case
                        model.location
                      of
                        Nothing ->
                            errorSection
                                "Unable to render summary view"
                                "Expecting a instance of type Location but nothing was found"

                        Just l ->
                            div
                                [ class "location-summary"
                                ]
                                [ div
                                    [ class "icon"
                                    ]
                                    [ (iconHtml
                                        l.icon
                                      )
                                    ]
                                , div
                                    [ class "area"
                                    ]
                                    [ (textHtml
                                        l.area
                                      )
                                    ]
                                , div
                                    [ class "region"
                                    ]
                                    [ (textHtml
                                        l.region
                                      )
                                    ]
                                , div
                                    [ class "country"
                                    ]
                                    [ (textHtml
                                        l.country
                                      )
                                    ]
                                ]
                    ]
                ]
            , div
                [ class "row actions"
                ]
                [ div
                    [ class "col-md-12"
                    ]
                    [ button
                        [ type_ "submit"
                        , class "btn btn-primary"
                        , onClick
                            OnChooseActionBrowseCategories
                        ]
                        [ text
                            "Browse Categories"
                        ]
                    , button
                        [ type_ "submit"
                        , class "btn btn-primary"
                        , onClick
                            OnChooseActionSearchAgain
                        ]
                        [ text
                            "Search Again"
                        ]
                    ]
                ]
            ]
        ]


searchingPageForSearchCategoryFlowInStateSearchingView : Model -> Html Msg
searchingPageForSearchCategoryFlowInStateSearchingView model =
    div
        []
        [ div
            [ class
                "container"
            ]
            [ div
                [ class
                    "row"
                ]
                [ div
                    [ class
                        "col-md-12"
                    ]
                    [ h1
                        []
                        [ text
                            "Searching ..."
                        ]
                    , h3
                        []
                        [ text
                            "Please wait"
                        ]
                    ]
                ]
            ]
        ]


categoriesSearchResultsPageForSearchCategoryFlowInStateFoundView : Model -> Html Msg
categoriesSearchResultsPageForSearchCategoryFlowInStateFoundView model =
    div
        []
        [ mainMenu
            model
        , div
            [ class
                "container"
            ]
            [ div
                [ class
                    "col-md-12"
                ]
                [ div
                    [ class
                        "row"
                    ]
                    [ h1
                        []
                        [ text
                            "Categories"
                        ]
                    , h3
                        []
                        [ text
                            ""
                        ]
                    , div
                        []
                        [ case
                            model.categories
                          of
                            Nothing ->
                                emptyListView

                            Just l ->
                                case
                                    List.isEmpty
                                        l
                                of
                                    True ->
                                        emptyListView

                                    False ->
                                        ul
                                            [ class "categories-list"
                                            ]
                                            (List.map
                                                categoriesListItemViewInFlowSearchCategory
                                                l
                                            )
                        ]
                    ]
                ]
            , div
                [ class "row actions"
                ]
                [ div
                    [ class "col-md-12"
                    ]
                    [ button
                        [ type_ "submit"
                        , class "btn btn-primary"
                        , onClick
                            OnSearchCategoryBackToLocations
                        ]
                        [ text
                            "Back to Locations"
                        ]
                    ]
                ]
            ]
        ]


categoryOptionsPageForSearchCategoryOptionsFlowInStateSuccessView : Model -> Html Msg
categoryOptionsPageForSearchCategoryOptionsFlowInStateSuccessView model =
    div
        []
        [ mainMenu
            model
        , div
            [ class
                "container"
            ]
            [ div
                [ class
                    "row"
                ]
                [ div
                    [ class
                        "col-md-12"
                    ]
                    [ h1
                        []
                        [ text
                            "Refine your search"
                        ]
                    , h3
                        []
                        [ text
                            ""
                        ]
                    , case
                        model.categoryOptions
                      of
                        Nothing ->
                            errorSection
                                "Unable to render form view"
                                "Expecting a instance of type CategoryOptions but nothing was found"

                        Just co ->
                            categoryOptionsFormView
                                co
                                model
                    ]
                ]
            , div
                [ class "row actions"
                ]
                [ div
                    [ class "col-md-12"
                    ]
                    [ button
                        [ type_ "submit"
                        , class "btn btn-primary"
                        , onClick
                            OnSearchCategoryOptionsBackToCategories
                        ]
                        [ text
                            "Back to categories"
                        ]
                    , button
                        [ type_ "submit"
                        , class "btn btn-primary"
                        , onClick
                            OnSearchCategoryOptionsTopRecommendations
                        ]
                        [ text
                            "Top recommendations"
                        ]
                    ]
                ]
            ]
        ]


searchingPageForSearchCategoryOptionsFlowInStateSearchingView : Model -> Html Msg
searchingPageForSearchCategoryOptionsFlowInStateSearchingView model =
    div
        []
        [ div
            [ class
                "container"
            ]
            [ div
                [ class
                    "row"
                ]
                [ div
                    [ class
                        "col-md-12"
                    ]
                    [ h1
                        []
                        [ text
                            "Searching ..."
                        ]
                    , h3
                        []
                        [ text
                            "Please wait"
                        ]
                    ]
                ]
            ]
        ]


topRecommendationsForSearchTopRecommendationsFlowInStateFoundView : Model -> Html Msg
topRecommendationsForSearchTopRecommendationsFlowInStateFoundView model =
    div
        []
        [ mainMenu
            model
        , div
            [ class
                "container"
            ]
            [ div
                [ class
                    "row"
                ]
                [ div
                    [ class
                        "col-md-12"
                    ]
                    [ h1
                        []
                        [ text
                            "Top Recommendations"
                        ]
                    , h3
                        []
                        [ text
                            ""
                        ]
                    , div
                        []
                        [ case
                            model.recommendationSearchResults
                          of
                            Nothing ->
                                emptyListView

                            Just l ->
                                case
                                    List.isEmpty
                                        l
                                of
                                    True ->
                                        emptyListView

                                    False ->
                                        ul
                                            [ class "recommendation-search-results-list"
                                            ]
                                            (List.map
                                                recommendationSearchResultsListItemViewInFlowSearchTopRecommendations
                                                l
                                            )
                        ]
                    ]
                ]
            , div
                [ class "row actions"
                ]
                [ div
                    [ class "col-md-12"
                    ]
                    [ button
                        [ type_ "submit"
                        , class "btn btn-primary"
                        , onClick
                            OnSearchTopRecommendationsRefineYourSearch
                        ]
                        [ text
                            "Refine your search"
                        ]
                    ]
                ]
            ]
        ]


searchingPageForSearchTopRecommendationsFlowInStateSearchingView : Model -> Html Msg
searchingPageForSearchTopRecommendationsFlowInStateSearchingView model =
    div
        []
        [ div
            [ class
                "container"
            ]
            [ div
                [ class
                    "row"
                ]
                [ div
                    [ class
                        "col-md-12"
                    ]
                    [ h1
                        []
                        [ text
                            "Searching ..."
                        ]
                    , h3
                        []
                        [ text
                            "Please wait"
                        ]
                    ]
                ]
            ]
        ]


allRecommendationsForSearchRelatedRecommendationsFlowInStateFoundView : Model -> Html Msg
allRecommendationsForSearchRelatedRecommendationsFlowInStateFoundView model =
    div
        []
        [ div
            [ class
                "container"
            ]
            [ div
                [ class
                    "row"
                ]
                [ div
                    [ class
                        "col-md-12"
                    ]
                    [ h1
                        []
                        [ text
                            "All recommendations"
                        ]
                    , h3
                        []
                        [ text
                            "Here are all the recommendations"
                        ]
                    , div
                        []
                        [ case
                            model.recommendationSearchResults
                          of
                            Nothing ->
                                emptyListView

                            Just l ->
                                case
                                    List.isEmpty
                                        l
                                of
                                    True ->
                                        emptyListView

                                    False ->
                                        ul
                                            [ class "recommendation-search-results-list"
                                            ]
                                            (List.map
                                                recommendationSearchResultsListItemViewInFlowSearchRelatedRecommendations
                                                l
                                            )
                        ]
                    ]
                ]
            , div
                [ class "row actions"
                ]
                [ div
                    [ class "col-md-12"
                    ]
                    [ button
                        [ type_ "submit"
                        , class "btn btn-primary"
                        , onClick
                            OnSearchRelatedRecommendationsBackToTopRecommendations
                        ]
                        [ text
                            "Back to top recommendations"
                        ]
                    ]
                ]
            ]
        ]


searchingPageForSearchRelatedRecommendationsFlowInStateSearchingView : Model -> Html Msg
searchingPageForSearchRelatedRecommendationsFlowInStateSearchingView model =
    div
        []
        [ div
            [ class
                "container"
            ]
            [ div
                [ class
                    "row"
                ]
                [ div
                    [ class
                        "col-md-12"
                    ]
                    [ h1
                        []
                        [ text
                            "Searching ..."
                        ]
                    , h3
                        []
                        [ text
                            "Please wait"
                        ]
                    ]
                ]
            ]
        ]


loginPageForLoginFlowInStateReadyView : Model -> Html Msg
loginPageForLoginFlowInStateReadyView model =
    div
        []
        [ div
            [ class
                "container"
            ]
            [ div
                [ class
                    "row"
                ]
                [ div
                    [ class
                        "col-md-12"
                    ]
                    [ h1
                        []
                        [ text
                            "Login"
                        ]
                    , h3
                        []
                        [ text
                            "Please enter your credentials"
                        ]
                    , case
                        model.credentials
                      of
                        Nothing ->
                            errorSection
                                "Unable to render form view"
                                "Expecting a instance of type Credentials but nothing was found"

                        Just c ->
                            credentialsFormView
                                c
                                model
                    ]
                ]
            , div
                [ class "row actions"
                ]
                [ div
                    [ class "col-md-12"
                    ]
                    [ button
                        [ type_ "submit"
                        , class "btn btn-primary"
                        , onClick
                            OnLoginSend
                        ]
                        [ text
                            "Send"
                        ]
                    ]
                ]
            ]
        ]


registerPageForRegisterFlowInStateReadyView : Model -> Html Msg
registerPageForRegisterFlowInStateReadyView model =
    div
        []
        [ div
            [ class
                "container"
            ]
            [ div
                [ class
                    "row"
                ]
                [ div
                    [ class
                        "col-md-12"
                    ]
                    [ h1
                        []
                        [ text
                            "Login"
                        ]
                    , h3
                        []
                        [ text
                            "Please enter your credentials"
                        ]
                    , case
                        model.credentials
                      of
                        Nothing ->
                            errorSection
                                "Unable to render form view"
                                "Expecting a instance of type Credentials but nothing was found"

                        Just c ->
                            credentialsFormView
                                c
                                model
                    ]
                ]
            , div
                [ class "row actions"
                ]
                [ div
                    [ class "col-md-12"
                    ]
                    [ button
                        [ type_ "submit"
                        , class "btn btn-primary"
                        , onClick
                            OnRegisterRegister
                        ]
                        [ text
                            "Register"
                        ]
                    ]
                ]
            ]
        ]


recommendationDetailForShowRecommendationDetailFlowInStateFoundView : Model -> Html Msg
recommendationDetailForShowRecommendationDetailFlowInStateFoundView model =
    div
        []
        [ mainMenu
            model
        , div
            [ class
                "container"
            ]
            [ div
                [ class
                    "row"
                ]
                [ div
                    [ class
                        "col-md-6"
                    ]
                    [ h1
                        []
                        [ text
                            "Detail"
                        ]
                    , h3
                        []
                        [ text
                            ""
                        ]
                    , case
                        model.recommendationDetail
                      of
                        Nothing ->
                            errorSection
                                "Unable to render summary view"
                                "Expecting a instance of type RecommendationDetail but nothing was found"

                        Just rd ->
                            div
                                [ class "recommendation-detail-summary"
                                ]
                                [ div
                                    [ class "summary"
                                    ]
                                    [ (textHtml
                                        rd.summary
                                      )
                                    ]
                                , div
                                    [ class "highlights"
                                    ]
                                    [ (paragraphsHtml
                                        rd.highlights
                                      )
                                    ]
                                , div
                                    [ class "author"
                                    ]
                                    [ (textHtml
                                        rd.author
                                      )
                                    ]
                                , div
                                    [ class "date"
                                    ]
                                    [ (datetimeHtml
                                        rd.date
                                      )
                                    ]
                                , div
                                    [ class "score"
                                    ]
                                    [ (integerHtml
                                        rd.score
                                      )
                                    ]
                                ]
                    , div
                        []
                        [ case
                            model.recommendationPhotos
                          of
                            Nothing ->
                                emptyListView

                            Just l ->
                                case
                                    List.isEmpty
                                        l
                                of
                                    True ->
                                        emptyListView

                                    False ->
                                        ul
                                            [ class "recommendation-photos-list"
                                            ]
                                            (List.map
                                                recommendationPhotosListItemViewInFlowShowRecommendationDetail
                                                l
                                            )
                        ]
                    ]
                , div
                    [ class
                        "col-md-6"
                    ]
                    [ h1
                        []
                        [ text
                            "Other recommendations"
                        ]
                    , h3
                        []
                        [ text
                            ""
                        ]
                    ]
                ]
            , div
                [ class "row actions"
                ]
                [ div
                    [ class "col-md-12"
                    ]
                    [ button
                        [ type_ "submit"
                        , class "btn btn-primary"
                        , onClick
                            OnShowRecommendationDetailTopRecommendations
                        ]
                        [ text
                            "Top recommendations"
                        ]
                    ]
                ]
            ]
        ]


searchingPageForSearchLocationFlowInStateSearchingView : Model -> Html Msg
searchingPageForSearchLocationFlowInStateSearchingView model =
    div
        []
        [ div
            [ class
                "container"
            ]
            [ div
                [ class
                    "row"
                ]
                [ div
                    [ class
                        "col-md-12"
                    ]
                    [ h1
                        []
                        [ text
                            "Searching ..."
                        ]
                    , h3
                        []
                        [ text
                            "Please wait"
                        ]
                    ]
                ]
            ]
        ]


locationSearchPageForSearchLocationFlowInStateReadyView : Model -> Html Msg
locationSearchPageForSearchLocationFlowInStateReadyView model =
    div
        []
        [ mainMenu
            model
        , div
            [ class
                "container"
            ]
            [ div
                [ class
                    "col-md-12"
                ]
                [ div
                    [ class
                        "row"
                    ]
                    [ h1
                        []
                        [ text
                            "Search a location"
                        ]
                    , h3
                        []
                        [ text
                            ""
                        ]
                    , case
                        model.locationSearch
                      of
                        Nothing ->
                            errorSection
                                "Unable to render form view"
                                "Expecting a instance of type LocationSearch but nothing was found"

                        Just ls ->
                            locationSearchFormView
                                ls
                                model
                    ]
                ]
            , div
                [ class "row actions"
                ]
                [ div
                    [ class "col-md-12"
                    ]
                    [ button
                        [ type_ "submit"
                        , class "btn btn-primary"
                        , onClick
                            OnSearchLocationSearch
                        ]
                        [ text
                            "Search"
                        ]
                    ]
                ]
            ]
        ]


activeClass : Bool -> String
activeClass active =
    case
        active
    of
        False ->
            ""

        True ->
            "active"


menuItem : MenuItem -> Html Msg
menuItem item =
    li
        [ class
            (activeClass
                item.active
            )
        ]
        [ a
            [ href
                "#"
            , onClick
                item.msg
            ]
            [ text
                item.label
            ]
        ]


isMenuItemInRoles : Roles -> MenuItem -> Bool
isMenuItemInRoles roles item =
    not
        (Set.isEmpty
            (Set.intersect
                (Set.fromList
                    roles
                )
                (Set.fromList
                    item.roles
                )
            )
        )


renderMenuItems : MenuItems -> List (Html Msg)
renderMenuItems items =
    List.map
        renderMenuItem
        items


renderMenuItem : MenuItem -> Html Msg
renderMenuItem item =
    menuItem
        item


filterMenuItems : Maybe Session -> MenuItems -> MenuItems
filterMenuItems session items =
    case
        session
    of
        Nothing ->
            []

        Just s ->
            List.filter
                (isMenuItemInRoles
                    s.roles
                )
                items


mainMenuItems : MenuItems
mainMenuItems =
    [ { msg =
            StartLogin
      , label =
            "Login"
      , roles =
            [ "Visitor"
            ]
      , active =
            False
      }
    , { msg =
            StartRegister
      , label =
            "Register"
      , roles =
            [ "Visitor"
            ]
      , active =
            False
      }
    ]


mainMenu : Model -> Html Msg
mainMenu model =
    nav
        [ class
            "navbar navbar-default navbar-fixed-top"
        ]
        [ div
            [ class
                "container"
            ]
            [ div
                [ class
                    "navbar-header"
                ]
                [ button
                    [ type_
                        "button"
                    , class
                        "navbar-toggle collapsed"
                    , attribute "data-toggle"
                        "collapse"
                    , attribute "data-target"
                        "#navbar"
                    , attribute "aria-expanded"
                        "false"
                    , attribute "aria-controls"
                        "navbar"
                    ]
                    [ span
                        [ class
                            "sr-only"
                        ]
                        [ text
                            "Toggle navigation"
                        ]
                    , span
                        [ class
                            "icon-bar"
                        ]
                        []
                    , span
                        [ class
                            "icon-bar"
                        ]
                        []
                    , span
                        [ class
                            "icon-bar"
                        ]
                        []
                    ]
                , a
                    [ class
                        "navbar-brand"
                    , href
                        "#"
                    ]
                    [ i
                        [ class "fa fa-hand-spock-o"
                        ]
                        []
                    , span
                        [ class "brand"
                        ]
                        [ text
                            "weekonekt"
                        ]
                    ]
                ]
            , div
                [ id
                    "navbar"
                , class
                    "navbar-collapse collapse"
                ]
                [ ul
                    [ class
                        "nav navbar-nav"
                    ]
                    (renderMenuItems
                        (filterMenuItems
                            model.session
                            mainMenuItems
                        )
                    )
                ]
            ]
        ]


textHtml : Text -> Html Msg
textHtml v =
    span
        []
        [ text
            (textToString
                v
            )
        ]


securedTextHtml : SecuredText -> Html Msg
securedTextHtml v =
    span
        []
        [ text
            (securedTextToString
                v
            )
        ]


integerHtml : Integer -> Html Msg
integerHtml v =
    span
        []
        [ text
            (integerToString
                v
            )
        ]


decimalHtml : Decimal -> Html Msg
decimalHtml v =
    span
        []
        [ text
            (decimalToString
                v
            )
        ]


booleanHtml : Boolean -> Html Msg
booleanHtml v =
    span
        []
        [ text
            (booleanToString
                v
            )
        ]


datetimeHtml : Datetime -> Html Msg
datetimeHtml v =
    span
        []
        [ text
            (datetimeToString
                v
            )
        ]


currencyHtml : Currency -> Html Msg
currencyHtml v =
    span
        []
        [ text
            (currencyToString
                v
            )
        ]


emailAddressHtml : EmailAddress -> Html Msg
emailAddressHtml v =
    span
        []
        [ text
            (emailAddressToString
                v
            )
        ]


languageHtml : Language -> Html Msg
languageHtml v =
    span
        []
        [ text
            (languageToString
                v
            )
        ]


phoneNumberHtml : PhoneNumber -> Html Msg
phoneNumberHtml v =
    span
        []
        [ text
            (phoneNumberToString
                v
            )
        ]


countryHtml : Country -> Html Msg
countryHtml v =
    span
        []
        [ text
            (countryToString
                v
            )
        ]


cityHtml : City -> Html Msg
cityHtml v =
    span
        []
        [ text
            (cityToString
                v
            )
        ]


zipCodeHtml : ZipCode -> Html Msg
zipCodeHtml v =
    span
        []
        [ text
            (zipCodeToString
                v
            )
        ]


linkHtml : Link -> Html Msg
linkHtml v =
    span
        []
        [ text
            (linkToString
                v
            )
        ]


headingHtml : Heading -> Html Msg
headingHtml v =
    span
        []
        [ text
            (headingToString
                v
            )
        ]


quoteHtml : Quote -> Html Msg
quoteHtml v =
    span
        []
        [ text
            (quoteToString
                v
            )
        ]


paragraphHtml : Paragraph -> Html Msg
paragraphHtml v =
    p
        [ class "paragraph"
        ]
        [ text
            v
        ]


severityHtml : Severity -> Html Msg
severityHtml v =
    span
        []
        [ text
            (severityToString
                v
            )
        ]


iconHtml : Icon -> Html Msg
iconHtml v =
    i
        [ class
            ("fa fa-"
                ++ v
            )
        ]
        []


labelHtml : Label -> Html Msg
labelHtml v =
    span
        []
        [ text
            (labelToString
                v
            )
        ]


choicesHtml : Choices -> Html Msg
choicesHtml v =
    span
        []
        [ text
            "Rendering of choices not yet implemented"
        ]


paragraphsHtml : Paragraphs -> Html Msg
paragraphsHtml v =
    div
        [ class "paragraphs"
        ]
        (List.map
            (\para ->
                p
                    [ class "paragraph"
                    ]
                    [ text
                        para
                    ]
            )
            v
        )
