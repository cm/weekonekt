module Models exposing (..)


type alias Id =
    Maybe String


type alias Flags =
    { apiHost : String
    }


type alias Error =
    { summary : String
    , description : String
    }


type alias Choices =
    { values : List Choice
    , selected : Id
    }


type alias Choice =
    { id : Id
    , label : String
    }


type alias Model =
    { flags : Flags
    , state : State
    , error : Maybe Error
    , page : Page
    , credentials : Maybe Credentials
    , identity : Maybe Identity
    , infoMessage : Maybe InfoMessage
    , passwordRecovery : Maybe PasswordRecovery
    , info : Maybe Info
    , recommendationSearch : Maybe RecommendationSearch
    , location : Maybe Location
    , category : Maybe Category
    , categoryOption : Maybe CategoryOption
    , locationSearch : Maybe LocationSearch
    , recommendationDetailSearch : Maybe RecommendationDetailSearch
    , categorySearch : Maybe CategorySearch
    , categoryOptionsSearch : Maybe CategoryOptionsSearch
    , recommendationSummary : Maybe RecommendationSummary
    , recommendationRelatedSearch : Maybe RecommendationRelatedSearch
    , recommendationAspect : Maybe RecommendationAspect
    , recommendationAspectsSearch : Maybe RecommendationAspectsSearch
    , recommendationDetail : Maybe RecommendationDetail
    , recommendationPhotoSearch : Maybe RecommendationPhotoSearch
    , recommendationPhoto : Maybe RecommendationPhoto
    , locations : Maybe Locations
    , categories : Maybe Categories
    , recommendationSearchResults : Maybe RecommendationSearchResults
    , recommendationPhotos : Maybe RecommendationPhotos
    , categoryOptions : Maybe CategoryOptions
    , recommendationAspects : Maybe RecommendationAspects
    , session : Maybe Session
    }


type alias Paragraphs =
    List Paragraph


type alias Text =
    String


type alias SecuredText =
    String


type alias Integer =
    Int


type alias Decimal =
    Float


type alias Boolean =
    Bool


type alias Datetime =
    String


type alias Currency =
    String


type alias EmailAddress =
    String


type alias Language =
    String


type alias PhoneNumber =
    String


type alias Country =
    String


type alias City =
    String


type alias ZipCode =
    String


type alias Link =
    String


type alias Heading =
    String


type alias Quote =
    String


type alias Paragraph =
    String


type alias Severity =
    String


type alias Icon =
    String


type alias Label =
    String


type alias Credentials =
    { username : Text
    , password : SecuredText
    , rememberMe : Maybe Boolean
    , id : Id
    }


type alias Identity =
    { firstName : Text
    , lastName : Text
    , username : Text
    , email : EmailAddress
    , preferredLanguage : Maybe Language
    , country : Country
    , id : Id
    }


type alias InfoMessage =
    { title : Heading
    , description : Paragraph
    , level : Severity
    , id : Id
    }


type alias PasswordRecovery =
    { email : EmailAddress
    , id : Id
    }


type alias Info =
    { name : Text
    , version : Text
    , database : Boolean
    , id : Id
    }


type alias RecommendationSearch =
    { id : Id
    }


type alias Location =
    { icon : Icon
    , area : Text
    , region : Text
    , country : Text
    , id : Id
    }


type alias Category =
    { icon : Icon
    , name : Text
    , description : Text
    , id : Id
    }


type alias CategoryOption =
    { icon : Icon
    , aspect : Label
    , choices : Choices
    , id : Id
    }


type alias LocationSearch =
    { keywords : Text
    , id : Id
    }


type alias RecommendationDetailSearch =
    { id : Id
    }


type alias CategorySearch =
    { id : Id
    }


type alias CategoryOptionsSearch =
    { keywords : Text
    , id : Id
    }


type alias RecommendationSummary =
    { summary : Text
    , highlights : Paragraphs
    , id : Id
    }


type alias RecommendationRelatedSearch =
    { id : Id
    }


type alias RecommendationAspect =
    { title : Heading
    , contents : Paragraphs
    , id : Id
    }


type alias RecommendationAspectsSearch =
    { id : Id
    }


type alias RecommendationDetail =
    { summary : Text
    , highlights : Paragraphs
    , author : Text
    , date : Datetime
    , score : Integer
    , id : Id
    }


type alias RecommendationPhotoSearch =
    { id : Id
    }


type alias RecommendationPhoto =
    { description : Text
    , id : Id
    }


type alias Locations =
    List Location


type alias Categories =
    List Category


type alias RecommendationSearchResults =
    List RecommendationSummary


type alias RecommendationPhotos =
    List RecommendationPhoto


type alias CategoryOptions =
    List CategoryOption


type alias RecommendationAspects =
    List RecommendationAspect


type alias Session =
    { roles : Roles
    }


type alias Role =
    String


type alias Roles =
    List Role


type alias State =
    { session : SessionState
    , connection : ConnectionState
    , welcome : WelcomeState
    , selectLocation : SelectLocationState
    , chooseAction : ChooseActionState
    , searchCategory : SearchCategoryState
    , searchCategoryOptions : SearchCategoryOptionsState
    , searchTopRecommendations : SearchTopRecommendationsState
    , searchRelatedRecommendations : SearchRelatedRecommendationsState
    , login : LoginState
    , register : RegisterState
    , showRecommendationDetail : ShowRecommendationDetailState
    , searchLocation : SearchLocationState
    , searchRecommendationPhotos : SearchRecommendationPhotosState
    }


type SessionState
    = SessionUnknown
    | SessionChecking
    | SessionChecked
    | SessionError


type ConnectionState
    = ConnectionOffline
    | ConnectionChecking
    | ConnectionOnline
    | ConnectionError


type WelcomeState
    = WelcomeVisitor
    | WelcomeUser
    | WelcomeError


type SelectLocationState
    = SelectLocationUnselected
    | SelectLocationSelected
    | SelectLocationNotInitialized
    | SelectLocationError


type ChooseActionState
    = ChooseActionUnselected
    | ChooseActionInput
    | ChooseActionOutput
    | ChooseActionNotInitialized
    | ChooseActionError


type SearchCategoryState
    = SearchCategoryNotStarted
    | SearchCategoryReady
    | SearchCategorySearching
    | SearchCategoryFound
    | SearchCategoryNotFound
    | SearchCategoryError


type SearchCategoryOptionsState
    = SearchCategoryOptionsNotStarted
    | SearchCategoryOptionsSearching
    | SearchCategoryOptionsSuccess
    | SearchCategoryOptionsStarted
    | SearchCategoryOptionsError


type SearchTopRecommendationsState
    = SearchTopRecommendationsNotStarted
    | SearchTopRecommendationsSearching
    | SearchTopRecommendationsFound
    | SearchTopRecommendationsError
    | SearchTopRecommendationsReady


type SearchRelatedRecommendationsState
    = SearchRelatedRecommendationsNotStarted
    | SearchRelatedRecommendationsSearching
    | SearchRelatedRecommendationsFound
    | SearchRelatedRecommendationsNotFound
    | SearchRelatedRecommendationsReady
    | SearchRelatedRecommendationsError


type LoginState
    = LoginNotInitialized
    | LoginReady
    | LoginVerifying
    | LoginError


type RegisterState
    = RegisterNotInitialized
    | RegisterReady
    | RegisterRegistering
    | RegisterCreated
    | RegisterConflict
    | RegisterError


type ShowRecommendationDetailState
    = ShowRecommendationDetailNotStarted
    | ShowRecommendationDetailReady
    | ShowRecommendationDetailRetrieving
    | ShowRecommendationDetailFound
    | ShowRecommendationDetailNotFound
    | ShowRecommendationDetailError


type SearchLocationState
    = SearchLocationReady
    | SearchLocationSearching
    | SearchLocationFound
    | SearchLocationNotFound
    | SearchLocationNotReady
    | SearchLocationError


type SearchRecommendationPhotosState
    = SearchRecommendationPhotosNotStarted
    | SearchRecommendationPhotosReady
    | SearchRecommendationPhotosSearching
    | SearchRecommendationPhotosFound
    | SearchRecommendationPhotosNotFound
    | SearchRecommendationPhotosError


type Page
    = ErrorPage
    | CheckingSessionPageForSessionFlowInStateChecking
    | ConnectingPageForConnectionFlowInStateChecking
    | UserLandingPageForWelcomeFlowInStateUser
    | LocationsSearchResultsForSelectLocationFlowInStateUnselected
    | ActionSelectionPageForChooseActionFlowInStateUnselected
    | SearchingPageForSearchCategoryFlowInStateSearching
    | CategoriesSearchResultsPageForSearchCategoryFlowInStateFound
    | CategoryOptionsPageForSearchCategoryOptionsFlowInStateSuccess
    | SearchingPageForSearchCategoryOptionsFlowInStateSearching
    | TopRecommendationsForSearchTopRecommendationsFlowInStateFound
    | SearchingPageForSearchTopRecommendationsFlowInStateSearching
    | AllRecommendationsForSearchRelatedRecommendationsFlowInStateFound
    | SearchingPageForSearchRelatedRecommendationsFlowInStateSearching
    | LoginPageForLoginFlowInStateReady
    | RegisterPageForRegisterFlowInStateReady
    | RecommendationDetailForShowRecommendationDetailFlowInStateFound
    | SearchingPageForSearchLocationFlowInStateSearching
    | LocationSearchPageForSearchLocationFlowInStateReady


init : Flags -> Model
init flags =
    { flags = flags
    , error = Nothing
    , credentials = Nothing
    , identity = Nothing
    , infoMessage = Nothing
    , passwordRecovery = Nothing
    , info = Nothing
    , recommendationSearch = Nothing
    , location = Nothing
    , category = Nothing
    , categoryOption = Nothing
    , locationSearch = Nothing
    , recommendationDetailSearch = Nothing
    , categorySearch = Nothing
    , categoryOptionsSearch = Nothing
    , recommendationSummary = Nothing
    , recommendationRelatedSearch = Nothing
    , recommendationAspect = Nothing
    , recommendationAspectsSearch = Nothing
    , recommendationDetail = Nothing
    , recommendationPhotoSearch = Nothing
    , recommendationPhoto = Nothing
    , locations = Nothing
    , categories = Nothing
    , recommendationSearchResults = Nothing
    , recommendationPhotos = Nothing
    , categoryOptions = Nothing
    , recommendationAspects = Nothing
    , session = Nothing
    , state =
        { session = SessionUnknown
        , connection = ConnectionChecking
        , welcome = WelcomeVisitor
        , selectLocation = SelectLocationNotInitialized
        , chooseAction = ChooseActionNotInitialized
        , searchCategory = SearchCategoryNotStarted
        , searchCategoryOptions = SearchCategoryOptionsNotStarted
        , searchTopRecommendations = SearchTopRecommendationsNotStarted
        , searchRelatedRecommendations = SearchRelatedRecommendationsNotStarted
        , login = LoginNotInitialized
        , register = RegisterNotInitialized
        , showRecommendationDetail = ShowRecommendationDetailNotStarted
        , searchLocation = SearchLocationNotReady
        , searchRecommendationPhotos = SearchRecommendationPhotosNotStarted
        }
    , page = ConnectingPageForConnectionFlowInStateChecking
    }
