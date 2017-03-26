module Commands exposing (..)

import Rest exposing (get, post, put, delete)
import Http exposing (jsonBody, Body)
import Models exposing (..)
import Urls exposing (..)
import Messages exposing (..)
import Decoders exposing (..)
import Encoders exposing (..)


fetchSession : Flags -> Cmd Msg
fetchSession flags =
    get
        (sessionUrl
            flags
        )
        sessionDecoder
        SessionFetched


fetchInfo : Flags -> Cmd Msg
fetchInfo flags =
    get
        (infoUrl
            flags
        )
        infoDecoder
        InfoFetched


createCategorySearch : CategorySearch -> Location -> Flags -> Cmd Msg
createCategorySearch cs l flags =
    post
        (categorySearchUrl
            flags
        )
        ((encodeCategorySearch
            cs
            l
         )
            |> jsonBody
        )
        categoriesDecoder
        CategorySearchCreated


createCategoryOptionsSearch : CategoryOptionsSearch -> Category -> Flags -> Cmd Msg
createCategoryOptionsSearch cos c flags =
    post
        (categoryOptionsSearchUrl
            flags
        )
        ((encodeCategoryOptionsSearch
            cos
            c
         )
            |> jsonBody
        )
        categoryOptionsDecoder
        CategoryOptionsSearchCreated


createRecommendationSearch : RecommendationSearch -> CategoryOptions -> Location -> Category -> Flags -> Cmd Msg
createRecommendationSearch rs co l c flags =
    post
        (recommendationSearchUrl
            flags
        )
        ((encodeRecommendationSearch
            rs
            co
            l
            c
         )
            |> jsonBody
        )
        recommendationSearchResultsDecoder
        RecommendationSearchCreated


createRecommendationRelatedSearch : RecommendationRelatedSearch -> RecommendationSummary -> Flags -> Cmd Msg
createRecommendationRelatedSearch rrs rs flags =
    post
        (recommendationRelatedSearchUrl
            flags
        )
        ((encodeRecommendationRelatedSearch
            rrs
            rs
         )
            |> jsonBody
        )
        recommendationSearchResultsDecoder
        RecommendationRelatedSearchCreated


createIdentity : Identity -> Flags -> Cmd Msg
createIdentity i flags =
    post
        (identityUrl
            flags
        )
        ((encodeIdentity
            i
         )
            |> jsonBody
        )
        identityDecoder
        IdentityCreated


createRecommendationDetailSearch : RecommendationDetailSearch -> RecommendationSummary -> Flags -> Cmd Msg
createRecommendationDetailSearch rds rs flags =
    post
        (recommendationDetailSearchUrl
            flags
        )
        ((encodeRecommendationDetailSearch
            rds
            rs
         )
            |> jsonBody
        )
        recommendationDetailDecoder
        RecommendationDetailSearchCreated


createLocationSearch : LocationSearch -> Flags -> Cmd Msg
createLocationSearch ls flags =
    post
        (locationSearchUrl
            flags
        )
        ((encodeLocationSearch
            ls
         )
            |> jsonBody
        )
        locationsDecoder
        LocationSearchCreated


createRecommendationPhotoSearch : RecommendationPhotoSearch -> RecommendationSummary -> Flags -> Cmd Msg
createRecommendationPhotoSearch rps rs flags =
    post
        (recommendationPhotoSearchUrl
            flags
        )
        ((encodeRecommendationPhotoSearch
            rps
            rs
         )
            |> jsonBody
        )
        recommendationPhotosDecoder
        RecommendationPhotoSearchCreated
