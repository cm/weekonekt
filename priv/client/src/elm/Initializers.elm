module Initializers exposing (..)

import Models exposing (..)


newSession : Session
newSession =
    { roles = []
    }


newCredentials : Credentials
newCredentials =
    { id = Nothing
    , username = ""
    , password = ""
    , rememberMe = Nothing
    }


newIdentity : Identity
newIdentity =
    { id = Nothing
    , firstName = ""
    , lastName = ""
    , username = ""
    , email = ""
    , preferredLanguage = Nothing
    , country = ""
    }


newInfoMessage : InfoMessage
newInfoMessage =
    { id = Nothing
    , title = ""
    , description = ""
    , level = ""
    }


newPasswordRecovery : PasswordRecovery
newPasswordRecovery =
    { id = Nothing
    , email = ""
    }


newInfo : Info
newInfo =
    { id = Nothing
    , name = ""
    , version = ""
    , database = False
    }


newRecommendationSearch : RecommendationSearch
newRecommendationSearch =
    { id = Nothing
    }


newLocation : Location
newLocation =
    { id = Nothing
    , icon = ""
    , area = ""
    , region = ""
    , country = ""
    }


newCategory : Category
newCategory =
    { id = Nothing
    , icon = ""
    , name = ""
    , description = ""
    }


newCategoryOption : CategoryOption
newCategoryOption =
    { id = Nothing
    , icon = ""
    , aspect = ""
    , choices = { values = [], selected = Nothing }
    }


newLocationSearch : LocationSearch
newLocationSearch =
    { id = Nothing
    , keywords = ""
    }


newRecommendationDetailSearch : RecommendationDetailSearch
newRecommendationDetailSearch =
    { id = Nothing
    }


newCategorySearch : CategorySearch
newCategorySearch =
    { id = Nothing
    }


newCategoryOptionsSearch : CategoryOptionsSearch
newCategoryOptionsSearch =
    { id = Nothing
    , keywords = ""
    }


newRecommendationSummary : RecommendationSummary
newRecommendationSummary =
    { id = Nothing
    , summary = ""
    , highlights = []
    }


newRecommendationRelatedSearch : RecommendationRelatedSearch
newRecommendationRelatedSearch =
    { id = Nothing
    }


newRecommendationAspect : RecommendationAspect
newRecommendationAspect =
    { id = Nothing
    , title = ""
    , contents = []
    }


newRecommendationAspectsSearch : RecommendationAspectsSearch
newRecommendationAspectsSearch =
    { id = Nothing
    }


newRecommendationDetail : RecommendationDetail
newRecommendationDetail =
    { id = Nothing
    , summary = ""
    , highlights = []
    , author = ""
    , date = ""
    , score = 0
    }


newRecommendationPhotoSearch : RecommendationPhotoSearch
newRecommendationPhotoSearch =
    { id = Nothing
    }


newRecommendationPhoto : RecommendationPhoto
newRecommendationPhoto =
    { id = Nothing
    , description = ""
    }
