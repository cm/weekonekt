module Update exposing (..)

import Messages exposing (..)
import Models exposing (..)
import Helpers exposing (..)
import Conditions exposing (..)
import Initializers exposing (..)
import Commands exposing (..)
import Finders exposing (..)
import Mutators exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case
        msg
    of
        StartLogin ->
            case
                allTrue
                    []
            of
                True ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | login = LoginReady
                                    }
                        , page = LoginPageForLoginFlowInStateReady
                        , credentials =
                            Just
                                newCredentials
                      }
                    , Cmd.none
                    )

                False ->
                    noTransitionError
                        model

        StartRegister ->
            case
                allTrue
                    []
            of
                True ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | register = RegisterReady
                                    }
                        , page = RegisterPageForRegisterFlowInStateReady
                        , identity =
                            Just
                                newIdentity
                      }
                    , Cmd.none
                    )

                False ->
                    noTransitionError
                        model

        StartWelcome ->
            case
                allTrue
                    [ sessionRolesContainsVisitor
                        model
                    ]
            of
                True ->
                    update
                        StartSearchLocation
                        { model
                            | state =
                                case
                                    model.state
                                of
                                    s ->
                                        { s
                                            | welcome = WelcomeVisitor
                                        }
                        }

                False ->
                    case
                        allTrue
                            [ sessionRolesDoesNotContainVisitor
                                model
                            ]
                    of
                        True ->
                            ( { model
                                | state =
                                    case
                                        model.state
                                    of
                                        s ->
                                            { s
                                                | welcome = WelcomeUser
                                            }
                                , page = UserLandingPageForWelcomeFlowInStateUser
                              }
                            , Cmd.none
                            )

                        False ->
                            noTransitionError
                                model

        StartConnection ->
            case
                allTrue
                    []
            of
                True ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | connection = ConnectionChecking
                                    }
                        , page = ConnectingPageForConnectionFlowInStateChecking
                      }
                    , Cmd.batch
                        [ (fetchInfo
                            model.flags
                          )
                        ]
                    )

                False ->
                    noTransitionError
                        model

        StartSession ->
            case
                allTrue
                    []
            of
                True ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | session = SessionChecking
                                    }
                        , page = CheckingSessionPageForSessionFlowInStateChecking
                      }
                    , Cmd.batch
                        [ (fetchSession
                            model.flags
                          )
                        ]
                    )

                False ->
                    noTransitionError
                        model

        StartSearchLocation ->
            case
                allTrue
                    []
            of
                True ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | searchLocation = SearchLocationReady
                                    }
                        , page = LocationSearchPageForSearchLocationFlowInStateReady
                        , locationSearch =
                            Just
                                newLocationSearch
                      }
                    , Cmd.none
                    )

                False ->
                    noTransitionError
                        model

        StartSearchCategory ->
            case
                allTrue
                    []
            of
                True ->
                    update
                        SearchInFlowSearchCategoryInStateReady
                        { model
                            | state =
                                case
                                    model.state
                                of
                                    s ->
                                        { s
                                            | searchCategory = SearchCategoryReady
                                        }
                            , categorySearch =
                                Just
                                    newCategorySearch
                        }

                False ->
                    noTransitionError
                        model

        StartSearchCategoryOptions ->
            case
                allTrue
                    []
            of
                True ->
                    update
                        SearchInFlowSearchCategoryOptionsInStateStarted
                        { model
                            | state =
                                case
                                    model.state
                                of
                                    s ->
                                        { s
                                            | searchCategoryOptions = SearchCategoryOptionsStarted
                                        }
                            , categoryOptionsSearch =
                                Just
                                    newCategoryOptionsSearch
                        }

                False ->
                    noTransitionError
                        model

        StartSelectLocation ->
            case
                allTrue
                    []
            of
                True ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | selectLocation = SelectLocationUnselected
                                    }
                        , page = LocationsSearchResultsForSelectLocationFlowInStateUnselected
                      }
                    , Cmd.none
                    )

                False ->
                    noTransitionError
                        model

        StartSearchTopRecommendations ->
            case
                allTrue
                    []
            of
                True ->
                    update
                        SearchInFlowSearchTopRecommendationsInStateReady
                        { model
                            | state =
                                case
                                    model.state
                                of
                                    s ->
                                        { s
                                            | searchTopRecommendations = SearchTopRecommendationsReady
                                        }
                            , recommendationSearch =
                                Just
                                    newRecommendationSearch
                        }

                False ->
                    noTransitionError
                        model

        StartShowRecommendationDetail ->
            case
                allTrue
                    []
            of
                True ->
                    update
                        SearchInFlowShowRecommendationDetailInStateReady
                        { model
                            | state =
                                case
                                    model.state
                                of
                                    s ->
                                        { s
                                            | showRecommendationDetail = ShowRecommendationDetailReady
                                        }
                            , recommendationDetailSearch =
                                Just
                                    newRecommendationDetailSearch
                        }

                False ->
                    noTransitionError
                        model

        StartSearchRecommendationPhotos ->
            case
                allTrue
                    []
            of
                True ->
                    update
                        SearchInFlowSearchRecommendationPhotosInStateReady
                        { model
                            | state =
                                case
                                    model.state
                                of
                                    s ->
                                        { s
                                            | searchRecommendationPhotos = SearchRecommendationPhotosReady
                                        }
                            , recommendationPhotoSearch =
                                Just
                                    newRecommendationPhotoSearch
                        }

                False ->
                    noTransitionError
                        model

        SearchInFlowSearchCategoryInStateReady ->
            case
                allTrue
                    []
            of
                True ->
                    case
                        model.location
                    of
                        Nothing ->
                            error
                                model
                                "Missing Location"
                                "No instance of Location was found in model"

                        Just l ->
                            case
                                model.categorySearch
                            of
                                Nothing ->
                                    error
                                        model
                                        "Missing Category Search"
                                        "No instance of CategorySearch was found in model"

                                Just cs ->
                                    ( { model
                                        | state =
                                            case
                                                model.state
                                            of
                                                s ->
                                                    { s
                                                        | searchCategory = SearchCategorySearching
                                                    }
                                        , page = SearchingPageForSearchCategoryFlowInStateSearching
                                      }
                                    , Cmd.batch
                                        [ (createCategorySearch
                                            cs
                                            l
                                            model.flags
                                          )
                                        ]
                                    )

                False ->
                    noTransitionError
                        model

        SearchInFlowSearchCategoryOptionsInStateStarted ->
            case
                allTrue
                    []
            of
                True ->
                    case
                        model.category
                    of
                        Nothing ->
                            error
                                model
                                "Missing Category"
                                "No instance of Category was found in model"

                        Just c ->
                            case
                                model.categoryOptionsSearch
                            of
                                Nothing ->
                                    error
                                        model
                                        "Missing Category Options Search"
                                        "No instance of CategoryOptionsSearch was found in model"

                                Just cos ->
                                    ( { model
                                        | state =
                                            case
                                                model.state
                                            of
                                                s ->
                                                    { s
                                                        | searchCategoryOptions = SearchCategoryOptionsSearching
                                                    }
                                        , page = SearchingPageForSearchCategoryOptionsFlowInStateSearching
                                      }
                                    , Cmd.batch
                                        [ (createCategoryOptionsSearch
                                            cos
                                            c
                                            model.flags
                                          )
                                        ]
                                    )

                False ->
                    noTransitionError
                        model

        SearchInFlowSearchTopRecommendationsInStateReady ->
            case
                allTrue
                    []
            of
                True ->
                    case
                        model.category
                    of
                        Nothing ->
                            error
                                model
                                "Missing Category"
                                "No instance of Category was found in model"

                        Just c ->
                            case
                                model.location
                            of
                                Nothing ->
                                    error
                                        model
                                        "Missing Location"
                                        "No instance of Location was found in model"

                                Just l ->
                                    case
                                        model.categoryOptions
                                    of
                                        Nothing ->
                                            error
                                                model
                                                "Missing Category Options"
                                                "No instance of CategoryOptions was found in model"

                                        Just co ->
                                            case
                                                model.recommendationSearch
                                            of
                                                Nothing ->
                                                    error
                                                        model
                                                        "Missing Recommendation Search"
                                                        "No instance of RecommendationSearch was found in model"

                                                Just rs ->
                                                    ( { model
                                                        | state =
                                                            case
                                                                model.state
                                                            of
                                                                s ->
                                                                    { s
                                                                        | searchTopRecommendations = SearchTopRecommendationsSearching
                                                                    }
                                                        , page = SearchingPageForSearchTopRecommendationsFlowInStateSearching
                                                      }
                                                    , Cmd.batch
                                                        [ (createRecommendationSearch
                                                            rs
                                                            co
                                                            l
                                                            c
                                                            model.flags
                                                          )
                                                        ]
                                                    )

                False ->
                    noTransitionError
                        model

        SearchInFlowSearchRelatedRecommendationsInStateReady ->
            case
                allTrue
                    []
            of
                True ->
                    case
                        model.recommendationSummary
                    of
                        Nothing ->
                            error
                                model
                                "Missing Recommendation Summary"
                                "No instance of RecommendationSummary was found in model"

                        Just rs ->
                            case
                                model.recommendationRelatedSearch
                            of
                                Nothing ->
                                    error
                                        model
                                        "Missing Recommendation Related Search"
                                        "No instance of RecommendationRelatedSearch was found in model"

                                Just rrs ->
                                    ( { model
                                        | state =
                                            case
                                                model.state
                                            of
                                                s ->
                                                    { s
                                                        | searchRelatedRecommendations = SearchRelatedRecommendationsSearching
                                                    }
                                        , page = SearchingPageForSearchRelatedRecommendationsFlowInStateSearching
                                      }
                                    , Cmd.batch
                                        [ (createRecommendationRelatedSearch
                                            rrs
                                            rs
                                            model.flags
                                          )
                                        ]
                                    )

                False ->
                    noTransitionError
                        model

        SearchInFlowShowRecommendationDetailInStateReady ->
            case
                allTrue
                    []
            of
                True ->
                    case
                        model.recommendationSummary
                    of
                        Nothing ->
                            error
                                model
                                "Missing Recommendation Summary"
                                "No instance of RecommendationSummary was found in model"

                        Just rs ->
                            case
                                model.recommendationDetailSearch
                            of
                                Nothing ->
                                    error
                                        model
                                        "Missing Recommendation Detail Search"
                                        "No instance of RecommendationDetailSearch was found in model"

                                Just rds ->
                                    ( { model
                                        | state =
                                            case
                                                model.state
                                            of
                                                s ->
                                                    { s
                                                        | showRecommendationDetail = ShowRecommendationDetailRetrieving
                                                    }
                                      }
                                    , Cmd.batch
                                        [ (createRecommendationDetailSearch
                                            rds
                                            rs
                                            model.flags
                                          )
                                        ]
                                    )

                False ->
                    noTransitionError
                        model

        SearchInFlowSearchRecommendationPhotosInStateReady ->
            case
                allTrue
                    []
            of
                True ->
                    case
                        model.recommendationSummary
                    of
                        Nothing ->
                            error
                                model
                                "Missing Recommendation Summary"
                                "No instance of RecommendationSummary was found in model"

                        Just rs ->
                            case
                                model.recommendationPhotoSearch
                            of
                                Nothing ->
                                    error
                                        model
                                        "Missing Recommendation Photo Search"
                                        "No instance of RecommendationPhotoSearch was found in model"

                                Just rps ->
                                    ( { model
                                        | state =
                                            case
                                                model.state
                                            of
                                                s ->
                                                    { s
                                                        | searchRecommendationPhotos = SearchRecommendationPhotosSearching
                                                    }
                                      }
                                    , Cmd.batch
                                        [ (createRecommendationPhotoSearch
                                            rps
                                            rs
                                            model.flags
                                          )
                                        ]
                                    )

                False ->
                    noTransitionError
                        model

        CategorySearchCreated (Ok c) ->
            case
                model.state.searchCategory
            of
                SearchCategorySearching ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | searchCategory = SearchCategoryFound
                                    }
                        , categories = Just c
                        , page = CategoriesSearchResultsPageForSearchCategoryFlowInStateFound
                      }
                    , Cmd.none
                    )

                _ ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | searchCategory = SearchCategoryError
                                    }
                        , error =
                            Just
                                (newError
                                    "Invalid State"
                                    "Trying to perform action CategorySearchCreated in an invalid state"
                                )
                        , page = ErrorPage
                      }
                    , Cmd.none
                    )

        CategorySearchCreated (Err e) ->
            case
                model.state.searchCategory
            of
                _ ->
                    (error
                        model
                        "Network Error"
                        (toString e)
                    )

        CategoryOptionsSearchCreated (Ok co) ->
            case
                model.state.searchCategoryOptions
            of
                SearchCategoryOptionsSearching ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | searchCategoryOptions = SearchCategoryOptionsSuccess
                                    }
                        , categoryOptions = Just co
                        , page = CategoryOptionsPageForSearchCategoryOptionsFlowInStateSuccess
                      }
                    , Cmd.none
                    )

                _ ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | searchCategoryOptions = SearchCategoryOptionsError
                                    }
                        , error =
                            Just
                                (newError
                                    "Invalid State"
                                    "Trying to perform action CategoryOptionsSearchCreated in an invalid state"
                                )
                        , page = ErrorPage
                      }
                    , Cmd.none
                    )

        CategoryOptionsSearchCreated (Err e) ->
            case
                model.state.searchCategoryOptions
            of
                _ ->
                    (error
                        model
                        "Network Error"
                        (toString e)
                    )

        RecommendationSearchCreated (Ok rsr) ->
            case
                model.state.searchTopRecommendations
            of
                SearchTopRecommendationsSearching ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | searchTopRecommendations = SearchTopRecommendationsFound
                                    }
                        , recommendationSearchResults = Just rsr
                        , page = TopRecommendationsForSearchTopRecommendationsFlowInStateFound
                      }
                    , Cmd.none
                    )

                _ ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | searchTopRecommendations = SearchTopRecommendationsError
                                    }
                        , error =
                            Just
                                (newError
                                    "Invalid State"
                                    "Trying to perform action RecommendationSearchCreated in an invalid state"
                                )
                        , page = ErrorPage
                      }
                    , Cmd.none
                    )

        RecommendationSearchCreated (Err e) ->
            case
                model.state.searchTopRecommendations
            of
                _ ->
                    (error
                        model
                        "Network Error"
                        (toString e)
                    )

        RecommendationRelatedSearchCreated (Ok rsr) ->
            case
                model.state.searchRelatedRecommendations
            of
                SearchRelatedRecommendationsSearching ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | searchRelatedRecommendations = SearchRelatedRecommendationsFound
                                    }
                        , recommendationSearchResults = Just rsr
                        , page = AllRecommendationsForSearchRelatedRecommendationsFlowInStateFound
                      }
                    , Cmd.none
                    )

                _ ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | searchRelatedRecommendations = SearchRelatedRecommendationsError
                                    }
                        , error =
                            Just
                                (newError
                                    "Invalid State"
                                    "Trying to perform action RecommendationRelatedSearchCreated in an invalid state"
                                )
                        , page = ErrorPage
                      }
                    , Cmd.none
                    )

        RecommendationRelatedSearchCreated (Err e) ->
            case
                model.state.searchRelatedRecommendations
            of
                _ ->
                    (error
                        model
                        "Network Error"
                        (toString e)
                    )

        IdentityCreated (Ok i) ->
            case
                model.state.register
            of
                RegisterRegistering ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | register = RegisterCreated
                                    }
                        , identity = Just i
                      }
                    , Cmd.none
                    )

                _ ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | register = RegisterError
                                    }
                        , error =
                            Just
                                (newError
                                    "Invalid State"
                                    "Trying to perform action IdentityCreated in an invalid state"
                                )
                        , page = ErrorPage
                      }
                    , Cmd.none
                    )

        IdentityCreated (Err e) ->
            case
                model.state.register
            of
                _ ->
                    (error
                        model
                        "Network Error"
                        (toString e)
                    )

        RecommendationDetailSearchCreated (Ok rd) ->
            case
                model.state.showRecommendationDetail
            of
                ShowRecommendationDetailRetrieving ->
                    update
                        StartSearchRecommendationPhotos
                        { model
                            | state =
                                case
                                    model.state
                                of
                                    s ->
                                        { s
                                            | showRecommendationDetail = ShowRecommendationDetailFound
                                        }
                            , recommendationDetail = Just rd
                            , page = RecommendationDetailForShowRecommendationDetailFlowInStateFound
                        }

                _ ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | showRecommendationDetail = ShowRecommendationDetailError
                                    }
                        , error =
                            Just
                                (newError
                                    "Invalid State"
                                    "Trying to perform action RecommendationDetailSearchCreated in an invalid state"
                                )
                        , page = ErrorPage
                      }
                    , Cmd.none
                    )

        RecommendationDetailSearchCreated (Err e) ->
            case
                model.state.showRecommendationDetail
            of
                _ ->
                    (error
                        model
                        "Network Error"
                        (toString e)
                    )

        LocationSearchCreated (Ok l) ->
            case
                model.state.searchLocation
            of
                SearchLocationSearching ->
                    update
                        StartSelectLocation
                        { model
                            | state =
                                case
                                    model.state
                                of
                                    s ->
                                        { s
                                            | searchLocation = SearchLocationFound
                                        }
                            , locations = Just l
                        }

                _ ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | searchLocation = SearchLocationError
                                    }
                        , error =
                            Just
                                (newError
                                    "Invalid State"
                                    "Trying to perform action LocationSearchCreated in an invalid state"
                                )
                        , page = ErrorPage
                      }
                    , Cmd.none
                    )

        LocationSearchCreated (Err e) ->
            case
                model.state.searchLocation
            of
                _ ->
                    (error
                        model
                        "Network Error"
                        (toString e)
                    )

        RecommendationPhotoSearchCreated (Ok rp) ->
            case
                model.state.searchRecommendationPhotos
            of
                SearchRecommendationPhotosSearching ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | searchRecommendationPhotos = SearchRecommendationPhotosFound
                                    }
                        , recommendationPhotos = Just rp
                      }
                    , Cmd.none
                    )

                _ ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | searchRecommendationPhotos = SearchRecommendationPhotosError
                                    }
                        , error =
                            Just
                                (newError
                                    "Invalid State"
                                    "Trying to perform action RecommendationPhotoSearchCreated in an invalid state"
                                )
                        , page = ErrorPage
                      }
                    , Cmd.none
                    )

        RecommendationPhotoSearchCreated (Err e) ->
            case
                model.state.searchRecommendationPhotos
            of
                _ ->
                    (error
                        model
                        "Network Error"
                        (toString e)
                    )

        FetchSession ->
            case
                model.state.session
            of
                SessionUnknown ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | session = SessionChecking
                                    }
                      }
                    , fetchSession
                        model.flags
                    )

                _ ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | session = SessionError
                                    }
                        , error =
                            Just
                                (newError
                                    "Invalid State"
                                    "Trying to perform action FetchSession in an invalid state"
                                )
                        , page = ErrorPage
                      }
                    , Cmd.none
                    )

        SessionFetched (Ok s) ->
            case
                model.state.session
            of
                SessionChecking ->
                    update
                        StartWelcome
                        { model
                            | state =
                                case
                                    model.state
                                of
                                    s ->
                                        { s
                                            | session = SessionChecked
                                        }
                            , session = Just s
                        }

                _ ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | session = SessionError
                                    }
                        , error =
                            Just
                                (newError
                                    "Invalid State"
                                    "Trying to perform action SessionFetched in an invalid state"
                                )
                        , page = ErrorPage
                      }
                    , Cmd.none
                    )

        SessionFetched (Err e) ->
            case
                model.state.session
            of
                _ ->
                    (error
                        model
                        "Network Error"
                        (toString e)
                    )

        FetchInfo ->
            case
                model.state.connection
            of
                ConnectionOffline ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | connection = ConnectionChecking
                                    }
                      }
                    , fetchInfo
                        model.flags
                    )

                ConnectionOnline ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | connection = ConnectionChecking
                                    }
                      }
                    , fetchInfo
                        model.flags
                    )

                _ ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | connection = ConnectionError
                                    }
                        , error =
                            Just
                                (newError
                                    "Invalid State"
                                    "Trying to perform action FetchInfo in an invalid state"
                                )
                        , page = ErrorPage
                      }
                    , Cmd.none
                    )

        InfoFetched (Ok i) ->
            case
                model.state.connection
            of
                ConnectionChecking ->
                    update
                        StartSession
                        { model
                            | state =
                                case
                                    model.state
                                of
                                    s ->
                                        { s
                                            | connection = ConnectionOnline
                                        }
                            , info = Just i
                        }

                _ ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | connection = ConnectionError
                                    }
                        , error =
                            Just
                                (newError
                                    "Invalid State"
                                    "Trying to perform action InfoFetched in an invalid state"
                                )
                        , page = ErrorPage
                      }
                    , Cmd.none
                    )

        InfoFetched (Err e) ->
            case
                model.state.connection
            of
                _ ->
                    (error
                        model
                        "Network Error"
                        (toString e)
                    )

        LocationSelectedInFlowSelectLocationInStateUnselected id ->
            case
                model.state.selectLocation
            of
                SelectLocationUnselected ->
                    case
                        model.locations
                    of
                        Nothing ->
                            error
                                model
                                "Missing collection"
                                "Collection Locations is not initialized yet"

                        Just l ->
                            case
                                findLocation
                                    id
                                    l
                            of
                                Nothing ->
                                    error
                                        model
                                        "Missing collection item"
                                        "A collection item of type Locations could not be found"

                                Just l ->
                                    update
                                        StartSearchCategory
                                        { model
                                            | state =
                                                case
                                                    model.state
                                                of
                                                    s ->
                                                        { s
                                                            | selectLocation = SelectLocationSelected
                                                        }
                                            , location = Just l
                                        }

                _ ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | selectLocation = SelectLocationError
                                    }
                        , error =
                            Just
                                (newError
                                    "Invalid State"
                                    "Trying to perform action LocationSelectedInFlowSelectLocationInStateUnselected id in an invalid state"
                                )
                        , page = ErrorPage
                      }
                    , Cmd.none
                    )

        CategorySelectedInFlowSearchCategoryInStateFound id ->
            case
                model.state.searchCategory
            of
                SearchCategoryFound ->
                    case
                        model.categories
                    of
                        Nothing ->
                            error
                                model
                                "Missing collection"
                                "Collection Categories is not initialized yet"

                        Just c ->
                            case
                                findCategory
                                    id
                                    c
                            of
                                Nothing ->
                                    error
                                        model
                                        "Missing collection item"
                                        "A collection item of type Categories could not be found"

                                Just c ->
                                    update
                                        StartSearchCategoryOptions
                                        { model
                                            | state =
                                                case
                                                    model.state
                                                of
                                                    s ->
                                                        { s
                                                            | searchCategory = SearchCategoryFound
                                                        }
                                            , category = Just c
                                        }

                _ ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | searchCategory = SearchCategoryError
                                    }
                        , error =
                            Just
                                (newError
                                    "Invalid State"
                                    "Trying to perform action CategorySelectedInFlowSearchCategoryInStateFound id in an invalid state"
                                )
                        , page = ErrorPage
                      }
                    , Cmd.none
                    )

        RecommendationSummarySelectedInFlowSearchTopRecommendationsInStateFound id ->
            case
                model.state.searchTopRecommendations
            of
                SearchTopRecommendationsFound ->
                    case
                        model.recommendationSearchResults
                    of
                        Nothing ->
                            error
                                model
                                "Missing collection"
                                "Collection RecommendationSearchResults is not initialized yet"

                        Just rsr ->
                            case
                                findRecommendationSummary
                                    id
                                    rsr
                            of
                                Nothing ->
                                    error
                                        model
                                        "Missing collection item"
                                        "A collection item of type RecommendationSearchResults could not be found"

                                Just rs ->
                                    update
                                        StartShowRecommendationDetail
                                        { model
                                            | state =
                                                case
                                                    model.state
                                                of
                                                    s ->
                                                        { s
                                                            | searchTopRecommendations = SearchTopRecommendationsFound
                                                        }
                                            , recommendationSummary = Just rs
                                        }

                _ ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | searchTopRecommendations = SearchTopRecommendationsError
                                    }
                        , error =
                            Just
                                (newError
                                    "Invalid State"
                                    "Trying to perform action RecommendationSummarySelectedInFlowSearchTopRecommendationsInStateFound id in an invalid state"
                                )
                        , page = ErrorPage
                      }
                    , Cmd.none
                    )

        RecommendationSummarySelectedInFlowSearchRelatedRecommendationsInStateFound id ->
            case
                model.state.searchRelatedRecommendations
            of
                SearchRelatedRecommendationsFound ->
                    case
                        model.recommendationSearchResults
                    of
                        Nothing ->
                            error
                                model
                                "Missing collection"
                                "Collection RecommendationSearchResults is not initialized yet"

                        Just rsr ->
                            case
                                findRecommendationSummary
                                    id
                                    rsr
                            of
                                Nothing ->
                                    error
                                        model
                                        "Missing collection item"
                                        "A collection item of type RecommendationSearchResults could not be found"

                                Just rs ->
                                    update
                                        StartShowRecommendationDetail
                                        { model
                                            | state =
                                                case
                                                    model.state
                                                of
                                                    s ->
                                                        { s
                                                            | searchRelatedRecommendations = SearchRelatedRecommendationsFound
                                                        }
                                            , recommendationSummary = Just rs
                                        }

                _ ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | searchRelatedRecommendations = SearchRelatedRecommendationsError
                                    }
                        , error =
                            Just
                                (newError
                                    "Invalid State"
                                    "Trying to perform action RecommendationSummarySelectedInFlowSearchRelatedRecommendationsInStateFound id in an invalid state"
                                )
                        , page = ErrorPage
                      }
                    , Cmd.none
                    )

        RecommendationPhotoSelectedInFlowShowRecommendationDetailInStateFound id ->
            case
                model.state.showRecommendationDetail
            of
                ShowRecommendationDetailFound ->
                    case
                        model.recommendationPhotos
                    of
                        Nothing ->
                            error
                                model
                                "Missing collection"
                                "Collection RecommendationPhotos is not initialized yet"

                        Just rp ->
                            case
                                findRecommendationPhoto
                                    id
                                    rp
                            of
                                Nothing ->
                                    error
                                        model
                                        "Missing collection item"
                                        "A collection item of type RecommendationPhotos could not be found"

                                Just rp ->
                                    ( { model
                                        | state =
                                            case
                                                model.state
                                            of
                                                s ->
                                                    { s
                                                        | showRecommendationDetail = ShowRecommendationDetailFound
                                                    }
                                        , recommendationPhoto = Just rp
                                      }
                                    , Cmd.none
                                    )

                _ ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | showRecommendationDetail = ShowRecommendationDetailError
                                    }
                        , error =
                            Just
                                (newError
                                    "Invalid State"
                                    "Trying to perform action RecommendationPhotoSelectedInFlowShowRecommendationDetailInStateFound id in an invalid state"
                                )
                        , page = ErrorPage
                      }
                    , Cmd.none
                    )

        OnCredentialsNewUsername id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.credentials
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Username"
                                "No instance of Credentials was found"

                        Just c ->
                            ( { model
                                | credentials =
                                    Just
                                        { c
                                            | username =
                                                (newCredentialsUsername
                                                    c.username
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    error
                        model
                        "Missing collection"
                        "Collection Credentials is not initialized yet"

        OnCredentialsNewPassword id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.credentials
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Password"
                                "No instance of Credentials was found"

                        Just c ->
                            ( { model
                                | credentials =
                                    Just
                                        { c
                                            | password =
                                                (newCredentialsPassword
                                                    c.password
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    error
                        model
                        "Missing collection"
                        "Collection Credentials is not initialized yet"

        OnCredentialsNewRememberMe id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.credentials
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property RememberMe"
                                "No instance of Credentials was found"

                        Just c ->
                            ( { model
                                | credentials =
                                    Just
                                        { c
                                            | rememberMe =
                                                Just
                                                    (newCredentialsRememberMe
                                                        c.rememberMe
                                                        value
                                                    )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    error
                        model
                        "Missing collection"
                        "Collection Credentials is not initialized yet"

        OnIdentityNewFirstName id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.identity
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property FirstName"
                                "No instance of Identity was found"

                        Just i ->
                            ( { model
                                | identity =
                                    Just
                                        { i
                                            | firstName =
                                                (newIdentityFirstName
                                                    i.firstName
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    error
                        model
                        "Missing collection"
                        "Collection Identity is not initialized yet"

        OnIdentityNewLastName id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.identity
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property LastName"
                                "No instance of Identity was found"

                        Just i ->
                            ( { model
                                | identity =
                                    Just
                                        { i
                                            | lastName =
                                                (newIdentityLastName
                                                    i.lastName
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    error
                        model
                        "Missing collection"
                        "Collection Identity is not initialized yet"

        OnIdentityNewUsername id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.identity
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Username"
                                "No instance of Identity was found"

                        Just i ->
                            ( { model
                                | identity =
                                    Just
                                        { i
                                            | username =
                                                (newIdentityUsername
                                                    i.username
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    error
                        model
                        "Missing collection"
                        "Collection Identity is not initialized yet"

        OnIdentityNewEmail id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.identity
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Email"
                                "No instance of Identity was found"

                        Just i ->
                            ( { model
                                | identity =
                                    Just
                                        { i
                                            | email =
                                                (newIdentityEmail
                                                    i.email
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    error
                        model
                        "Missing collection"
                        "Collection Identity is not initialized yet"

        OnIdentityNewPreferredLanguage id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.identity
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property PreferredLanguage"
                                "No instance of Identity was found"

                        Just i ->
                            ( { model
                                | identity =
                                    Just
                                        { i
                                            | preferredLanguage =
                                                Just
                                                    (newIdentityPreferredLanguage
                                                        i.preferredLanguage
                                                        value
                                                    )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    error
                        model
                        "Missing collection"
                        "Collection Identity is not initialized yet"

        OnIdentityNewCountry id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.identity
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Country"
                                "No instance of Identity was found"

                        Just i ->
                            ( { model
                                | identity =
                                    Just
                                        { i
                                            | country =
                                                (newIdentityCountry
                                                    i.country
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    error
                        model
                        "Missing collection"
                        "Collection Identity is not initialized yet"

        OnInfoMessageNewTitle id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.infoMessage
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Title"
                                "No instance of InfoMessage was found"

                        Just im ->
                            ( { model
                                | infoMessage =
                                    Just
                                        { im
                                            | title =
                                                (newInfoMessageTitle
                                                    im.title
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    error
                        model
                        "Missing collection"
                        "Collection InfoMessage is not initialized yet"

        OnInfoMessageNewDescription id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.infoMessage
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Description"
                                "No instance of InfoMessage was found"

                        Just im ->
                            ( { model
                                | infoMessage =
                                    Just
                                        { im
                                            | description =
                                                (newInfoMessageDescription
                                                    im.description
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    error
                        model
                        "Missing collection"
                        "Collection InfoMessage is not initialized yet"

        OnInfoMessageNewLevel id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.infoMessage
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Level"
                                "No instance of InfoMessage was found"

                        Just im ->
                            ( { model
                                | infoMessage =
                                    Just
                                        { im
                                            | level =
                                                (newInfoMessageLevel
                                                    im.level
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    error
                        model
                        "Missing collection"
                        "Collection InfoMessage is not initialized yet"

        OnPasswordRecoveryNewEmail id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.passwordRecovery
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Email"
                                "No instance of PasswordRecovery was found"

                        Just pr ->
                            ( { model
                                | passwordRecovery =
                                    Just
                                        { pr
                                            | email =
                                                (newPasswordRecoveryEmail
                                                    pr.email
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    error
                        model
                        "Missing collection"
                        "Collection PasswordRecovery is not initialized yet"

        OnInfoNewName id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.info
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Name"
                                "No instance of Info was found"

                        Just i ->
                            ( { model
                                | info =
                                    Just
                                        { i
                                            | name =
                                                (newInfoName
                                                    i.name
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    error
                        model
                        "Missing collection"
                        "Collection Info is not initialized yet"

        OnInfoNewVersion id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.info
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Version"
                                "No instance of Info was found"

                        Just i ->
                            ( { model
                                | info =
                                    Just
                                        { i
                                            | version =
                                                (newInfoVersion
                                                    i.version
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    error
                        model
                        "Missing collection"
                        "Collection Info is not initialized yet"

        OnInfoNewDatabase id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.info
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Database"
                                "No instance of Info was found"

                        Just i ->
                            ( { model
                                | info =
                                    Just
                                        { i
                                            | database =
                                                (newInfoDatabase
                                                    i.database
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    error
                        model
                        "Missing collection"
                        "Collection Info is not initialized yet"

        OnLocationNewIcon id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.location
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Icon"
                                "No instance of Location was found"

                        Just l ->
                            ( { model
                                | location =
                                    Just
                                        { l
                                            | icon =
                                                (newLocationIcon
                                                    l.icon
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    case
                        model.locations
                    of
                        Nothing ->
                            error
                                model
                                "Missing collection"
                                "Collection Locations is not initialized yet"

                        Just lL ->
                            case
                                findLocation
                                    id
                                    lL
                            of
                                Nothing ->
                                    error
                                        model
                                        "Missing collection item"
                                        "A collection item of type Location could not be found"

                                Just l ->
                                    ( { model
                                        | locations =
                                            Just
                                                (replaceLocation
                                                    lL
                                                    { l
                                                        | icon =
                                                            (newLocationIcon
                                                                l.icon
                                                                value
                                                            )
                                                    }
                                                )
                                      }
                                    , Cmd.none
                                    )

        OnLocationNewArea id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.location
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Area"
                                "No instance of Location was found"

                        Just l ->
                            ( { model
                                | location =
                                    Just
                                        { l
                                            | area =
                                                (newLocationArea
                                                    l.area
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    case
                        model.locations
                    of
                        Nothing ->
                            error
                                model
                                "Missing collection"
                                "Collection Locations is not initialized yet"

                        Just lL ->
                            case
                                findLocation
                                    id
                                    lL
                            of
                                Nothing ->
                                    error
                                        model
                                        "Missing collection item"
                                        "A collection item of type Location could not be found"

                                Just l ->
                                    ( { model
                                        | locations =
                                            Just
                                                (replaceLocation
                                                    lL
                                                    { l
                                                        | area =
                                                            (newLocationArea
                                                                l.area
                                                                value
                                                            )
                                                    }
                                                )
                                      }
                                    , Cmd.none
                                    )

        OnLocationNewRegion id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.location
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Region"
                                "No instance of Location was found"

                        Just l ->
                            ( { model
                                | location =
                                    Just
                                        { l
                                            | region =
                                                (newLocationRegion
                                                    l.region
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    case
                        model.locations
                    of
                        Nothing ->
                            error
                                model
                                "Missing collection"
                                "Collection Locations is not initialized yet"

                        Just lL ->
                            case
                                findLocation
                                    id
                                    lL
                            of
                                Nothing ->
                                    error
                                        model
                                        "Missing collection item"
                                        "A collection item of type Location could not be found"

                                Just l ->
                                    ( { model
                                        | locations =
                                            Just
                                                (replaceLocation
                                                    lL
                                                    { l
                                                        | region =
                                                            (newLocationRegion
                                                                l.region
                                                                value
                                                            )
                                                    }
                                                )
                                      }
                                    , Cmd.none
                                    )

        OnLocationNewCountry id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.location
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Country"
                                "No instance of Location was found"

                        Just l ->
                            ( { model
                                | location =
                                    Just
                                        { l
                                            | country =
                                                (newLocationCountry
                                                    l.country
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    case
                        model.locations
                    of
                        Nothing ->
                            error
                                model
                                "Missing collection"
                                "Collection Locations is not initialized yet"

                        Just lL ->
                            case
                                findLocation
                                    id
                                    lL
                            of
                                Nothing ->
                                    error
                                        model
                                        "Missing collection item"
                                        "A collection item of type Location could not be found"

                                Just l ->
                                    ( { model
                                        | locations =
                                            Just
                                                (replaceLocation
                                                    lL
                                                    { l
                                                        | country =
                                                            (newLocationCountry
                                                                l.country
                                                                value
                                                            )
                                                    }
                                                )
                                      }
                                    , Cmd.none
                                    )

        OnCategoryNewIcon id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.category
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Icon"
                                "No instance of Category was found"

                        Just c ->
                            ( { model
                                | category =
                                    Just
                                        { c
                                            | icon =
                                                (newCategoryIcon
                                                    c.icon
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    case
                        model.categories
                    of
                        Nothing ->
                            error
                                model
                                "Missing collection"
                                "Collection Categories is not initialized yet"

                        Just cL ->
                            case
                                findCategory
                                    id
                                    cL
                            of
                                Nothing ->
                                    error
                                        model
                                        "Missing collection item"
                                        "A collection item of type Category could not be found"

                                Just c ->
                                    ( { model
                                        | categories =
                                            Just
                                                (replaceCategory
                                                    cL
                                                    { c
                                                        | icon =
                                                            (newCategoryIcon
                                                                c.icon
                                                                value
                                                            )
                                                    }
                                                )
                                      }
                                    , Cmd.none
                                    )

        OnCategoryNewName id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.category
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Name"
                                "No instance of Category was found"

                        Just c ->
                            ( { model
                                | category =
                                    Just
                                        { c
                                            | name =
                                                (newCategoryName
                                                    c.name
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    case
                        model.categories
                    of
                        Nothing ->
                            error
                                model
                                "Missing collection"
                                "Collection Categories is not initialized yet"

                        Just cL ->
                            case
                                findCategory
                                    id
                                    cL
                            of
                                Nothing ->
                                    error
                                        model
                                        "Missing collection item"
                                        "A collection item of type Category could not be found"

                                Just c ->
                                    ( { model
                                        | categories =
                                            Just
                                                (replaceCategory
                                                    cL
                                                    { c
                                                        | name =
                                                            (newCategoryName
                                                                c.name
                                                                value
                                                            )
                                                    }
                                                )
                                      }
                                    , Cmd.none
                                    )

        OnCategoryNewDescription id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.category
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Description"
                                "No instance of Category was found"

                        Just c ->
                            ( { model
                                | category =
                                    Just
                                        { c
                                            | description =
                                                (newCategoryDescription
                                                    c.description
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    case
                        model.categories
                    of
                        Nothing ->
                            error
                                model
                                "Missing collection"
                                "Collection Categories is not initialized yet"

                        Just cL ->
                            case
                                findCategory
                                    id
                                    cL
                            of
                                Nothing ->
                                    error
                                        model
                                        "Missing collection item"
                                        "A collection item of type Category could not be found"

                                Just c ->
                                    ( { model
                                        | categories =
                                            Just
                                                (replaceCategory
                                                    cL
                                                    { c
                                                        | description =
                                                            (newCategoryDescription
                                                                c.description
                                                                value
                                                            )
                                                    }
                                                )
                                      }
                                    , Cmd.none
                                    )

        OnCategoryOptionNewIcon id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.categoryOption
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Icon"
                                "No instance of CategoryOption was found"

                        Just co ->
                            ( { model
                                | categoryOption =
                                    Just
                                        { co
                                            | icon =
                                                (newCategoryOptionIcon
                                                    co.icon
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    case
                        model.categoryOptions
                    of
                        Nothing ->
                            error
                                model
                                "Missing collection"
                                "Collection CategoryOptions is not initialized yet"

                        Just coL ->
                            case
                                findCategoryOption
                                    id
                                    coL
                            of
                                Nothing ->
                                    error
                                        model
                                        "Missing collection item"
                                        "A collection item of type CategoryOption could not be found"

                                Just co ->
                                    ( { model
                                        | categoryOptions =
                                            Just
                                                (replaceCategoryOption
                                                    coL
                                                    { co
                                                        | icon =
                                                            (newCategoryOptionIcon
                                                                co.icon
                                                                value
                                                            )
                                                    }
                                                )
                                      }
                                    , Cmd.none
                                    )

        OnCategoryOptionNewAspect id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.categoryOption
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Aspect"
                                "No instance of CategoryOption was found"

                        Just co ->
                            ( { model
                                | categoryOption =
                                    Just
                                        { co
                                            | aspect =
                                                (newCategoryOptionAspect
                                                    co.aspect
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    case
                        model.categoryOptions
                    of
                        Nothing ->
                            error
                                model
                                "Missing collection"
                                "Collection CategoryOptions is not initialized yet"

                        Just coL ->
                            case
                                findCategoryOption
                                    id
                                    coL
                            of
                                Nothing ->
                                    error
                                        model
                                        "Missing collection item"
                                        "A collection item of type CategoryOption could not be found"

                                Just co ->
                                    ( { model
                                        | categoryOptions =
                                            Just
                                                (replaceCategoryOption
                                                    coL
                                                    { co
                                                        | aspect =
                                                            (newCategoryOptionAspect
                                                                co.aspect
                                                                value
                                                            )
                                                    }
                                                )
                                      }
                                    , Cmd.none
                                    )

        OnCategoryOptionNewChoices id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.categoryOption
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Choices"
                                "No instance of CategoryOption was found"

                        Just co ->
                            ( { model
                                | categoryOption =
                                    Just
                                        { co
                                            | choices =
                                                (newCategoryOptionChoices
                                                    co.choices
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    case
                        model.categoryOptions
                    of
                        Nothing ->
                            error
                                model
                                "Missing collection"
                                "Collection CategoryOptions is not initialized yet"

                        Just coL ->
                            case
                                findCategoryOption
                                    id
                                    coL
                            of
                                Nothing ->
                                    error
                                        model
                                        "Missing collection item"
                                        "A collection item of type CategoryOption could not be found"

                                Just co ->
                                    ( { model
                                        | categoryOptions =
                                            Just
                                                (replaceCategoryOption
                                                    coL
                                                    { co
                                                        | choices =
                                                            (newCategoryOptionChoices
                                                                co.choices
                                                                value
                                                            )
                                                    }
                                                )
                                      }
                                    , Cmd.none
                                    )

        OnLocationSearchNewKeywords id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.locationSearch
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Keywords"
                                "No instance of LocationSearch was found"

                        Just ls ->
                            ( { model
                                | locationSearch =
                                    Just
                                        { ls
                                            | keywords =
                                                (newLocationSearchKeywords
                                                    ls.keywords
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    error
                        model
                        "Missing collection"
                        "Collection LocationSearch is not initialized yet"

        OnCategoryOptionsSearchNewKeywords id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.categoryOptionsSearch
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Keywords"
                                "No instance of CategoryOptionsSearch was found"

                        Just cos ->
                            ( { model
                                | categoryOptionsSearch =
                                    Just
                                        { cos
                                            | keywords =
                                                (newCategoryOptionsSearchKeywords
                                                    cos.keywords
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    error
                        model
                        "Missing collection"
                        "Collection CategoryOptionsSearch is not initialized yet"

        OnRecommendationSummaryNewSummary id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.recommendationSummary
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Summary"
                                "No instance of RecommendationSummary was found"

                        Just rs ->
                            ( { model
                                | recommendationSummary =
                                    Just
                                        { rs
                                            | summary =
                                                (newRecommendationSummarySummary
                                                    rs.summary
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    case
                        model.recommendationSearchResults
                    of
                        Nothing ->
                            error
                                model
                                "Missing collection"
                                "Collection RecommendationSearchResults is not initialized yet"

                        Just rsrL ->
                            case
                                findRecommendationSummary
                                    id
                                    rsrL
                            of
                                Nothing ->
                                    error
                                        model
                                        "Missing collection item"
                                        "A collection item of type RecommendationSummary could not be found"

                                Just rs ->
                                    ( { model
                                        | recommendationSearchResults =
                                            Just
                                                (replaceRecommendationSummary
                                                    rsrL
                                                    { rs
                                                        | summary =
                                                            (newRecommendationSummarySummary
                                                                rs.summary
                                                                value
                                                            )
                                                    }
                                                )
                                      }
                                    , Cmd.none
                                    )

        OnRecommendationSummaryNewHighlights id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.recommendationSummary
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Highlights"
                                "No instance of RecommendationSummary was found"

                        Just rs ->
                            ( { model
                                | recommendationSummary =
                                    Just
                                        { rs
                                            | highlights =
                                                (newRecommendationSummaryHighlights
                                                    rs.highlights
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    case
                        model.recommendationSearchResults
                    of
                        Nothing ->
                            error
                                model
                                "Missing collection"
                                "Collection RecommendationSearchResults is not initialized yet"

                        Just rsrL ->
                            case
                                findRecommendationSummary
                                    id
                                    rsrL
                            of
                                Nothing ->
                                    error
                                        model
                                        "Missing collection item"
                                        "A collection item of type RecommendationSummary could not be found"

                                Just rs ->
                                    ( { model
                                        | recommendationSearchResults =
                                            Just
                                                (replaceRecommendationSummary
                                                    rsrL
                                                    { rs
                                                        | highlights =
                                                            (newRecommendationSummaryHighlights
                                                                rs.highlights
                                                                value
                                                            )
                                                    }
                                                )
                                      }
                                    , Cmd.none
                                    )

        OnRecommendationAspectNewTitle id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.recommendationAspect
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Title"
                                "No instance of RecommendationAspect was found"

                        Just ra ->
                            ( { model
                                | recommendationAspect =
                                    Just
                                        { ra
                                            | title =
                                                (newRecommendationAspectTitle
                                                    ra.title
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    case
                        model.recommendationAspects
                    of
                        Nothing ->
                            error
                                model
                                "Missing collection"
                                "Collection RecommendationAspects is not initialized yet"

                        Just raL ->
                            case
                                findRecommendationAspect
                                    id
                                    raL
                            of
                                Nothing ->
                                    error
                                        model
                                        "Missing collection item"
                                        "A collection item of type RecommendationAspect could not be found"

                                Just ra ->
                                    ( { model
                                        | recommendationAspects =
                                            Just
                                                (replaceRecommendationAspect
                                                    raL
                                                    { ra
                                                        | title =
                                                            (newRecommendationAspectTitle
                                                                ra.title
                                                                value
                                                            )
                                                    }
                                                )
                                      }
                                    , Cmd.none
                                    )

        OnRecommendationAspectNewContents id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.recommendationAspect
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Contents"
                                "No instance of RecommendationAspect was found"

                        Just ra ->
                            ( { model
                                | recommendationAspect =
                                    Just
                                        { ra
                                            | contents =
                                                (newRecommendationAspectContents
                                                    ra.contents
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    case
                        model.recommendationAspects
                    of
                        Nothing ->
                            error
                                model
                                "Missing collection"
                                "Collection RecommendationAspects is not initialized yet"

                        Just raL ->
                            case
                                findRecommendationAspect
                                    id
                                    raL
                            of
                                Nothing ->
                                    error
                                        model
                                        "Missing collection item"
                                        "A collection item of type RecommendationAspect could not be found"

                                Just ra ->
                                    ( { model
                                        | recommendationAspects =
                                            Just
                                                (replaceRecommendationAspect
                                                    raL
                                                    { ra
                                                        | contents =
                                                            (newRecommendationAspectContents
                                                                ra.contents
                                                                value
                                                            )
                                                    }
                                                )
                                      }
                                    , Cmd.none
                                    )

        OnRecommendationDetailNewSummary id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.recommendationDetail
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Summary"
                                "No instance of RecommendationDetail was found"

                        Just rd ->
                            ( { model
                                | recommendationDetail =
                                    Just
                                        { rd
                                            | summary =
                                                (newRecommendationDetailSummary
                                                    rd.summary
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    error
                        model
                        "Missing collection"
                        "Collection RecommendationDetail is not initialized yet"

        OnRecommendationDetailNewHighlights id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.recommendationDetail
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Highlights"
                                "No instance of RecommendationDetail was found"

                        Just rd ->
                            ( { model
                                | recommendationDetail =
                                    Just
                                        { rd
                                            | highlights =
                                                (newRecommendationDetailHighlights
                                                    rd.highlights
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    error
                        model
                        "Missing collection"
                        "Collection RecommendationDetail is not initialized yet"

        OnRecommendationDetailNewAuthor id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.recommendationDetail
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Author"
                                "No instance of RecommendationDetail was found"

                        Just rd ->
                            ( { model
                                | recommendationDetail =
                                    Just
                                        { rd
                                            | author =
                                                (newRecommendationDetailAuthor
                                                    rd.author
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    error
                        model
                        "Missing collection"
                        "Collection RecommendationDetail is not initialized yet"

        OnRecommendationDetailNewDate id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.recommendationDetail
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Date"
                                "No instance of RecommendationDetail was found"

                        Just rd ->
                            ( { model
                                | recommendationDetail =
                                    Just
                                        { rd
                                            | date =
                                                (newRecommendationDetailDate
                                                    rd.date
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    error
                        model
                        "Missing collection"
                        "Collection RecommendationDetail is not initialized yet"

        OnRecommendationDetailNewScore id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.recommendationDetail
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Score"
                                "No instance of RecommendationDetail was found"

                        Just rd ->
                            ( { model
                                | recommendationDetail =
                                    Just
                                        { rd
                                            | score =
                                                (newRecommendationDetailScore
                                                    rd.score
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    error
                        model
                        "Missing collection"
                        "Collection RecommendationDetail is not initialized yet"

        OnRecommendationPhotoNewDescription id value ->
            case
                id
            of
                Nothing ->
                    case
                        model.recommendationPhoto
                    of
                        Nothing ->
                            error
                                model
                                "Can't update property Description"
                                "No instance of RecommendationPhoto was found"

                        Just rp ->
                            ( { model
                                | recommendationPhoto =
                                    Just
                                        { rp
                                            | description =
                                                (newRecommendationPhotoDescription
                                                    rp.description
                                                    value
                                                )
                                        }
                              }
                            , Cmd.none
                            )

                Just i ->
                    case
                        model.recommendationPhotos
                    of
                        Nothing ->
                            error
                                model
                                "Missing collection"
                                "Collection RecommendationPhotos is not initialized yet"

                        Just rpL ->
                            case
                                findRecommendationPhoto
                                    id
                                    rpL
                            of
                                Nothing ->
                                    error
                                        model
                                        "Missing collection item"
                                        "A collection item of type RecommendationPhoto could not be found"

                                Just rp ->
                                    ( { model
                                        | recommendationPhotos =
                                            Just
                                                (replaceRecommendationPhoto
                                                    rpL
                                                    { rp
                                                        | description =
                                                            (newRecommendationPhotoDescription
                                                                rp.description
                                                                value
                                                            )
                                                    }
                                                )
                                      }
                                    , Cmd.none
                                    )

        OnConnectionCheck ->
            ( { model
                | state =
                    case
                        model.state
                    of
                        s ->
                            { s
                                | connection = ConnectionChecking
                            }
              }
            , Cmd.batch
                [ (fetchInfo
                    model.flags
                  )
                ]
            )

        OnSelectLocationSearchAgain ->
            update
                StartSearchLocation
                { model
                    | state =
                        case
                            model.state
                        of
                            s ->
                                { s
                                    | selectLocation = SelectLocationNotInitialized
                                }
                }

        OnSelectLocationSelection ->
            update
                StartSearchCategory
                { model
                    | state =
                        case
                            model.state
                        of
                            s ->
                                { s
                                    | selectLocation = SelectLocationSelected
                                }
                }

        OnChooseActionBrowseCategories ->
            update
                StartSearchCategory
                { model
                    | state =
                        case
                            model.state
                        of
                            s ->
                                { s
                                    | chooseAction = ChooseActionOutput
                                }
                }

        OnChooseActionSearchAgain ->
            update
                StartSearchLocation
                { model
                    | state =
                        case
                            model.state
                        of
                            s ->
                                { s
                                    | chooseAction = ChooseActionNotInitialized
                                }
                }

        OnSearchCategorySearch ->
            case
                model.location
            of
                Nothing ->
                    error
                        model
                        "Missing Location"
                        "No instance of Location was found in model"

                Just l ->
                    case
                        model.categorySearch
                    of
                        Nothing ->
                            error
                                model
                                "Missing Category Search"
                                "No instance of CategorySearch was found in model"

                        Just cs ->
                            ( { model
                                | state =
                                    case
                                        model.state
                                    of
                                        s ->
                                            { s
                                                | searchCategory = SearchCategorySearching
                                            }
                                , page = SearchingPageForSearchCategoryFlowInStateSearching
                              }
                            , Cmd.batch
                                [ (createCategorySearch
                                    cs
                                    l
                                    model.flags
                                  )
                                ]
                            )

        OnSearchCategorySelection ->
            update
                StartSearchCategoryOptions
                { model
                    | state =
                        case
                            model.state
                        of
                            s ->
                                { s
                                    | searchCategory = SearchCategoryFound
                                }
                }

        OnSearchCategoryBackToLocations ->
            update
                StartSelectLocation
                { model
                    | state =
                        case
                            model.state
                        of
                            s ->
                                { s
                                    | searchCategory = SearchCategoryNotStarted
                                }
                }

        OnSearchCategoryOptionsBackToCategories ->
            update
                StartSearchCategory
                { model
                    | state =
                        case
                            model.state
                        of
                            s ->
                                { s
                                    | searchCategoryOptions = SearchCategoryOptionsNotStarted
                                }
                }

        OnSearchCategoryOptionsTopRecommendations ->
            update
                StartSearchTopRecommendations
                { model
                    | state =
                        case
                            model.state
                        of
                            s ->
                                { s
                                    | searchCategoryOptions = SearchCategoryOptionsSuccess
                                }
                }

        OnSearchCategoryOptionsSearch ->
            case
                model.category
            of
                Nothing ->
                    error
                        model
                        "Missing Category"
                        "No instance of Category was found in model"

                Just c ->
                    case
                        model.categoryOptionsSearch
                    of
                        Nothing ->
                            error
                                model
                                "Missing Category Options Search"
                                "No instance of CategoryOptionsSearch was found in model"

                        Just cos ->
                            ( { model
                                | state =
                                    case
                                        model.state
                                    of
                                        s ->
                                            { s
                                                | searchCategoryOptions = SearchCategoryOptionsSearching
                                            }
                                , page = SearchingPageForSearchCategoryOptionsFlowInStateSearching
                              }
                            , Cmd.batch
                                [ (createCategoryOptionsSearch
                                    cos
                                    c
                                    model.flags
                                  )
                                ]
                            )

        OnSearchTopRecommendationsSelection ->
            update
                StartShowRecommendationDetail
                { model
                    | state =
                        case
                            model.state
                        of
                            s ->
                                { s
                                    | searchTopRecommendations = SearchTopRecommendationsFound
                                }
                }

        OnSearchTopRecommendationsRefineYourSearch ->
            update
                StartSearchCategoryOptions
                { model
                    | state =
                        case
                            model.state
                        of
                            s ->
                                { s
                                    | searchTopRecommendations = SearchTopRecommendationsNotStarted
                                }
                }

        OnSearchTopRecommendationsSearch ->
            case
                model.category
            of
                Nothing ->
                    error
                        model
                        "Missing Category"
                        "No instance of Category was found in model"

                Just c ->
                    case
                        model.location
                    of
                        Nothing ->
                            error
                                model
                                "Missing Location"
                                "No instance of Location was found in model"

                        Just l ->
                            case
                                model.categoryOptions
                            of
                                Nothing ->
                                    error
                                        model
                                        "Missing Category Options"
                                        "No instance of CategoryOptions was found in model"

                                Just co ->
                                    case
                                        model.recommendationSearch
                                    of
                                        Nothing ->
                                            error
                                                model
                                                "Missing Recommendation Search"
                                                "No instance of RecommendationSearch was found in model"

                                        Just rs ->
                                            ( { model
                                                | state =
                                                    case
                                                        model.state
                                                    of
                                                        s ->
                                                            { s
                                                                | searchTopRecommendations = SearchTopRecommendationsSearching
                                                            }
                                                , page = SearchingPageForSearchTopRecommendationsFlowInStateSearching
                                              }
                                            , Cmd.batch
                                                [ (createRecommendationSearch
                                                    rs
                                                    co
                                                    l
                                                    c
                                                    model.flags
                                                  )
                                                ]
                                            )

        OnSearchRelatedRecommendationsSelection ->
            update
                StartShowRecommendationDetail
                { model
                    | state =
                        case
                            model.state
                        of
                            s ->
                                { s
                                    | searchRelatedRecommendations = SearchRelatedRecommendationsFound
                                }
                }

        OnSearchRelatedRecommendationsBackToTopRecommendations ->
            update
                StartSearchTopRecommendations
                { model
                    | state =
                        case
                            model.state
                        of
                            s ->
                                { s
                                    | searchRelatedRecommendations = SearchRelatedRecommendationsNotStarted
                                }
                }

        OnSearchRelatedRecommendationsBackToMainRecommendations ->
            ( { model
                | state =
                    case
                        model.state
                    of
                        s ->
                            { s
                                | searchRelatedRecommendations = SearchRelatedRecommendationsNotStarted
                            }
              }
            , Cmd.none
            )

        OnSearchRelatedRecommendationsSearch ->
            case
                model.recommendationSummary
            of
                Nothing ->
                    error
                        model
                        "Missing Recommendation Summary"
                        "No instance of RecommendationSummary was found in model"

                Just rs ->
                    case
                        model.recommendationRelatedSearch
                    of
                        Nothing ->
                            error
                                model
                                "Missing Recommendation Related Search"
                                "No instance of RecommendationRelatedSearch was found in model"

                        Just rrs ->
                            ( { model
                                | state =
                                    case
                                        model.state
                                    of
                                        s ->
                                            { s
                                                | searchRelatedRecommendations = SearchRelatedRecommendationsSearching
                                            }
                                , page = SearchingPageForSearchRelatedRecommendationsFlowInStateSearching
                              }
                            , Cmd.batch
                                [ (createRecommendationRelatedSearch
                                    rrs
                                    rs
                                    model.flags
                                  )
                                ]
                            )

        OnLoginSend ->
            ( { model
                | state =
                    case
                        model.state
                    of
                        s ->
                            { s
                                | login = LoginVerifying
                            }
              }
            , Cmd.none
            )

        OnRegisterRegister ->
            case
                model.identity
            of
                Nothing ->
                    error
                        model
                        "Missing Identity"
                        "No instance of Identity was found in model"

                Just i ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | register = RegisterRegistering
                                    }
                      }
                    , Cmd.batch
                        [ (createIdentity
                            i
                            model.flags
                          )
                        ]
                    )

        OnShowRecommendationDetailSearch ->
            case
                model.recommendationSummary
            of
                Nothing ->
                    error
                        model
                        "Missing Recommendation Summary"
                        "No instance of RecommendationSummary was found in model"

                Just rs ->
                    case
                        model.recommendationDetailSearch
                    of
                        Nothing ->
                            error
                                model
                                "Missing Recommendation Detail Search"
                                "No instance of RecommendationDetailSearch was found in model"

                        Just rds ->
                            ( { model
                                | state =
                                    case
                                        model.state
                                    of
                                        s ->
                                            { s
                                                | showRecommendationDetail = ShowRecommendationDetailRetrieving
                                            }
                              }
                            , Cmd.batch
                                [ (createRecommendationDetailSearch
                                    rds
                                    rs
                                    model.flags
                                  )
                                ]
                            )

        OnShowRecommendationDetailSelection ->
            ( { model
                | state =
                    case
                        model.state
                    of
                        s ->
                            { s
                                | showRecommendationDetail = ShowRecommendationDetailFound
                            }
              }
            , Cmd.none
            )

        OnShowRecommendationDetailTopRecommendations ->
            update
                StartSearchTopRecommendations
                { model
                    | state =
                        case
                            model.state
                        of
                            s ->
                                { s
                                    | showRecommendationDetail = ShowRecommendationDetailNotStarted
                                }
                }

        OnSearchLocationSearch ->
            case
                model.locationSearch
            of
                Nothing ->
                    error
                        model
                        "Missing Location Search"
                        "No instance of LocationSearch was found in model"

                Just ls ->
                    ( { model
                        | state =
                            case
                                model.state
                            of
                                s ->
                                    { s
                                        | searchLocation = SearchLocationSearching
                                    }
                        , page = SearchingPageForSearchLocationFlowInStateSearching
                      }
                    , Cmd.batch
                        [ (createLocationSearch
                            ls
                            model.flags
                          )
                        ]
                    )

        OnSearchLocationSelection ->
            update
                StartSearchCategory
                { model
                    | state =
                        case
                            model.state
                        of
                            s ->
                                { s
                                    | searchLocation = SearchLocationFound
                                }
                }

        OnSearchLocationSearchAgain ->
            update
                StartSearchLocation
                { model
                    | state =
                        case
                            model.state
                        of
                            s ->
                                { s
                                    | searchLocation = SearchLocationReady
                                }
                }

        OnSearchRecommendationPhotosSearch ->
            case
                model.recommendationSummary
            of
                Nothing ->
                    error
                        model
                        "Missing Recommendation Summary"
                        "No instance of RecommendationSummary was found in model"

                Just rs ->
                    case
                        model.recommendationPhotoSearch
                    of
                        Nothing ->
                            error
                                model
                                "Missing Recommendation Photo Search"
                                "No instance of RecommendationPhotoSearch was found in model"

                        Just rps ->
                            ( { model
                                | state =
                                    case
                                        model.state
                                    of
                                        s ->
                                            { s
                                                | searchRecommendationPhotos = SearchRecommendationPhotosSearching
                                            }
                              }
                            , Cmd.batch
                                [ (createRecommendationPhotoSearch
                                    rps
                                    rs
                                    model.flags
                                  )
                                ]
                            )
