module Urls exposing (..)

import Models exposing (..)


credentialsUrl : Flags -> String
credentialsUrl flags =
    flags.apiHost
        ++ "/api/credentials"


identityUrl : Flags -> String
identityUrl flags =
    flags.apiHost
        ++ "/api/identity"


infoMessageUrl : Flags -> String
infoMessageUrl flags =
    flags.apiHost
        ++ "/api/info/message"


passwordRecoveryUrl : Flags -> String
passwordRecoveryUrl flags =
    flags.apiHost
        ++ "/api/password/recovery"


sessionUrl : Flags -> String
sessionUrl flags =
    flags.apiHost
        ++ "/api/session"


infoUrl : Flags -> String
infoUrl flags =
    flags.apiHost
        ++ "/api/info"


recommendationSearchUrl : Flags -> String
recommendationSearchUrl flags =
    flags.apiHost
        ++ "/api/recommendation/search"


locationUrl : Flags -> String
locationUrl flags =
    flags.apiHost
        ++ "/api/location"


locationsUrl : Flags -> String
locationsUrl flags =
    flags.apiHost
        ++ "/api/locations"


categoryUrl : Flags -> String
categoryUrl flags =
    flags.apiHost
        ++ "/api/category"


categoriesUrl : Flags -> String
categoriesUrl flags =
    flags.apiHost
        ++ "/api/categories"


categoryOptionUrl : Flags -> String
categoryOptionUrl flags =
    flags.apiHost
        ++ "/api/category/option"


locationSearchUrl : Flags -> String
locationSearchUrl flags =
    flags.apiHost
        ++ "/api/location/search"


recommendationSearchResultsUrl : Flags -> String
recommendationSearchResultsUrl flags =
    flags.apiHost
        ++ "/api/recommendation/search/results"


recommendationDetailSearchUrl : Flags -> String
recommendationDetailSearchUrl flags =
    flags.apiHost
        ++ "/api/recommendation/detail/search"


recommendationPhotosUrl : Flags -> String
recommendationPhotosUrl flags =
    flags.apiHost
        ++ "/api/recommendation/photos"


categorySearchUrl : Flags -> String
categorySearchUrl flags =
    flags.apiHost
        ++ "/api/category/search"


categoryOptionsUrl : Flags -> String
categoryOptionsUrl flags =
    flags.apiHost
        ++ "/api/category/options"


categoryOptionsSearchUrl : Flags -> String
categoryOptionsSearchUrl flags =
    flags.apiHost
        ++ "/api/category/options/search"


recommendationSummaryUrl : Flags -> String
recommendationSummaryUrl flags =
    flags.apiHost
        ++ "/api/recommendation/summary"


recommendationRelatedSearchUrl : Flags -> String
recommendationRelatedSearchUrl flags =
    flags.apiHost
        ++ "/api/recommendation/related/search"


recommendationAspectUrl : Flags -> String
recommendationAspectUrl flags =
    flags.apiHost
        ++ "/api/recommendation/aspect"


recommendationAspectsUrl : Flags -> String
recommendationAspectsUrl flags =
    flags.apiHost
        ++ "/api/recommendation/aspects"


recommendationAspectsSearchUrl : Flags -> String
recommendationAspectsSearchUrl flags =
    flags.apiHost
        ++ "/api/recommendation/aspects/search"


recommendationDetailUrl : Flags -> String
recommendationDetailUrl flags =
    flags.apiHost
        ++ "/api/recommendation/detail"


recommendationPhotoSearchUrl : Flags -> String
recommendationPhotoSearchUrl flags =
    flags.apiHost
        ++ "/api/recommendation/photo/search"


recommendationPhotoUrl : Flags -> String
recommendationPhotoUrl flags =
    flags.apiHost
        ++ "/api/recommendation/photo"
