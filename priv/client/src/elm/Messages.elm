module Messages exposing (..)

import Http
import Models exposing (..)


type Msg
    = FetchSession
    | SessionFetched (Result Http.Error Session)
    | FetchInfo
    | InfoFetched (Result Http.Error Info)
    | CategorySearchCreated (Result Http.Error Categories)
    | CategoryOptionsSearchCreated (Result Http.Error CategoryOptions)
    | RecommendationSearchCreated (Result Http.Error RecommendationSearchResults)
    | RecommendationRelatedSearchCreated (Result Http.Error RecommendationSearchResults)
    | IdentityCreated (Result Http.Error Identity)
    | RecommendationDetailSearchCreated (Result Http.Error RecommendationDetail)
    | LocationSearchCreated (Result Http.Error Locations)
    | RecommendationPhotoSearchCreated (Result Http.Error RecommendationPhotos)
    | StartLogin
    | StartRegister
    | StartWelcome
    | StartConnection
    | StartSession
    | StartSearchLocation
    | StartSearchCategory
    | StartSearchCategoryOptions
    | StartSelectLocation
    | StartSearchTopRecommendations
    | StartShowRecommendationDetail
    | StartSearchRecommendationPhotos
    | SearchInFlowSearchCategoryInStateReady
    | SearchInFlowSearchCategoryOptionsInStateStarted
    | SearchInFlowSearchTopRecommendationsInStateReady
    | SearchInFlowSearchRelatedRecommendationsInStateReady
    | SearchInFlowShowRecommendationDetailInStateReady
    | SearchInFlowSearchRecommendationPhotosInStateReady
    | OnCredentialsNewUsername Id String
    | OnCredentialsNewPassword Id String
    | OnCredentialsNewRememberMe Id String
    | OnIdentityNewFirstName Id String
    | OnIdentityNewLastName Id String
    | OnIdentityNewUsername Id String
    | OnIdentityNewEmail Id String
    | OnIdentityNewPreferredLanguage Id String
    | OnIdentityNewCountry Id String
    | OnInfoMessageNewTitle Id String
    | OnInfoMessageNewDescription Id String
    | OnInfoMessageNewLevel Id String
    | OnPasswordRecoveryNewEmail Id String
    | OnInfoNewName Id String
    | OnInfoNewVersion Id String
    | OnInfoNewDatabase Id String
    | OnLocationNewIcon Id String
    | OnLocationNewArea Id String
    | OnLocationNewRegion Id String
    | OnLocationNewCountry Id String
    | OnCategoryNewIcon Id String
    | OnCategoryNewName Id String
    | OnCategoryNewDescription Id String
    | OnCategoryOptionNewIcon Id String
    | OnCategoryOptionNewAspect Id String
    | OnCategoryOptionNewChoices Id Id
    | OnLocationSearchNewKeywords Id String
    | OnCategoryOptionsSearchNewKeywords Id String
    | OnRecommendationSummaryNewSummary Id String
    | OnRecommendationSummaryNewHighlights Id Paragraphs
    | OnRecommendationAspectNewTitle Id String
    | OnRecommendationAspectNewContents Id Paragraphs
    | OnRecommendationDetailNewSummary Id String
    | OnRecommendationDetailNewHighlights Id Paragraphs
    | OnRecommendationDetailNewAuthor Id String
    | OnRecommendationDetailNewDate Id String
    | OnRecommendationDetailNewScore Id String
    | OnRecommendationPhotoNewDescription Id String
    | OnConnectionCheck
    | OnSelectLocationSearchAgain
    | OnSelectLocationSelection
    | OnChooseActionBrowseCategories
    | OnChooseActionSearchAgain
    | OnSearchCategorySearch
    | OnSearchCategorySelection
    | OnSearchCategoryBackToLocations
    | OnSearchCategoryOptionsBackToCategories
    | OnSearchCategoryOptionsTopRecommendations
    | OnSearchCategoryOptionsSearch
    | OnSearchTopRecommendationsSelection
    | OnSearchTopRecommendationsRefineYourSearch
    | OnSearchTopRecommendationsSearch
    | OnSearchRelatedRecommendationsSelection
    | OnSearchRelatedRecommendationsBackToTopRecommendations
    | OnSearchRelatedRecommendationsBackToMainRecommendations
    | OnSearchRelatedRecommendationsSearch
    | OnLoginSend
    | OnRegisterRegister
    | OnShowRecommendationDetailSearch
    | OnShowRecommendationDetailSelection
    | OnShowRecommendationDetailTopRecommendations
    | OnSearchLocationSearch
    | OnSearchLocationSelection
    | OnSearchLocationSearchAgain
    | OnSearchRecommendationPhotosSearch
    | LocationSelectedInFlowSelectLocationInStateUnselected Id
    | CategorySelectedInFlowSearchCategoryInStateFound Id
    | RecommendationSummarySelectedInFlowSearchTopRecommendationsInStateFound Id
    | RecommendationSummarySelectedInFlowSearchRelatedRecommendationsInStateFound Id
    | RecommendationPhotoSelectedInFlowShowRecommendationDetailInStateFound Id
