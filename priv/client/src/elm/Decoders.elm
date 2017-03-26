module Decoders exposing (..)

import Json.Decode exposing (Decoder, map, map2, map3, map4, map5, map6, map7, map8, maybe, field, list, string, int, bool)
import Models exposing (..)


strings : Decoder (List String)
strings =
    list
        string


paragraphs : Decoder (List Paragraph)
paragraphs =
    list
        paragraph


paragraph : Decoder Paragraph
paragraph =
    string


choices : Decoder Choices
choices =
    map2
        Choices
        (field
            "values"
            choicesValues
        )
        (maybe
            (field
                "selected"
                string
            )
        )


choicesValues : Decoder (List Choice)
choicesValues =
    list
        choice


choice : Decoder Choice
choice =
    map2
        Choice
        (maybe
            (field
                "id"
                string
            )
        )
        (field
            "label"
            string
        )


credentialsDecoder : Decoder Credentials
credentialsDecoder =
    map4
        Credentials
        (field
            "username"
            string
        )
        (field
            "password"
            string
        )
        (maybe
            (field
                "rememberMe"
                bool
            )
        )
        (maybe
            (field
                "id"
                string
            )
        )


identityDecoder : Decoder Identity
identityDecoder =
    map7
        Identity
        (field
            "firstName"
            string
        )
        (field
            "lastName"
            string
        )
        (field
            "username"
            string
        )
        (field
            "email"
            string
        )
        (maybe
            (field
                "preferredLanguage"
                string
            )
        )
        (field
            "country"
            string
        )
        (maybe
            (field
                "id"
                string
            )
        )


infoMessageDecoder : Decoder InfoMessage
infoMessageDecoder =
    map4
        InfoMessage
        (field
            "title"
            string
        )
        (field
            "description"
            paragraph
        )
        (field
            "level"
            string
        )
        (maybe
            (field
                "id"
                string
            )
        )


passwordRecoveryDecoder : Decoder PasswordRecovery
passwordRecoveryDecoder =
    map2
        PasswordRecovery
        (field
            "email"
            string
        )
        (maybe
            (field
                "id"
                string
            )
        )


infoDecoder : Decoder Info
infoDecoder =
    map4
        Info
        (field
            "name"
            string
        )
        (field
            "version"
            string
        )
        (field
            "database"
            bool
        )
        (maybe
            (field
                "id"
                string
            )
        )


recommendationSearchDecoder : Decoder RecommendationSearch
recommendationSearchDecoder =
    map
        RecommendationSearch
        (maybe
            (field
                "id"
                string
            )
        )


locationDecoder : Decoder Location
locationDecoder =
    map5
        Location
        (field
            "icon"
            string
        )
        (field
            "area"
            string
        )
        (field
            "region"
            string
        )
        (field
            "country"
            string
        )
        (maybe
            (field
                "id"
                string
            )
        )


categoryDecoder : Decoder Category
categoryDecoder =
    map4
        Category
        (field
            "icon"
            string
        )
        (field
            "name"
            string
        )
        (field
            "description"
            string
        )
        (maybe
            (field
                "id"
                string
            )
        )


categoryOptionDecoder : Decoder CategoryOption
categoryOptionDecoder =
    map4
        CategoryOption
        (field
            "icon"
            string
        )
        (field
            "aspect"
            string
        )
        (field
            "choices"
            choices
        )
        (maybe
            (field
                "id"
                string
            )
        )


locationSearchDecoder : Decoder LocationSearch
locationSearchDecoder =
    map2
        LocationSearch
        (field
            "keywords"
            string
        )
        (maybe
            (field
                "id"
                string
            )
        )


recommendationDetailSearchDecoder : Decoder RecommendationDetailSearch
recommendationDetailSearchDecoder =
    map
        RecommendationDetailSearch
        (maybe
            (field
                "id"
                string
            )
        )


categorySearchDecoder : Decoder CategorySearch
categorySearchDecoder =
    map
        CategorySearch
        (maybe
            (field
                "id"
                string
            )
        )


categoryOptionsSearchDecoder : Decoder CategoryOptionsSearch
categoryOptionsSearchDecoder =
    map2
        CategoryOptionsSearch
        (field
            "keywords"
            string
        )
        (maybe
            (field
                "id"
                string
            )
        )


recommendationSummaryDecoder : Decoder RecommendationSummary
recommendationSummaryDecoder =
    map3
        RecommendationSummary
        (field
            "summary"
            string
        )
        (field
            "highlights"
            paragraphs
        )
        (maybe
            (field
                "id"
                string
            )
        )


recommendationRelatedSearchDecoder : Decoder RecommendationRelatedSearch
recommendationRelatedSearchDecoder =
    map
        RecommendationRelatedSearch
        (maybe
            (field
                "id"
                string
            )
        )


recommendationAspectDecoder : Decoder RecommendationAspect
recommendationAspectDecoder =
    map3
        RecommendationAspect
        (field
            "title"
            string
        )
        (field
            "contents"
            paragraphs
        )
        (maybe
            (field
                "id"
                string
            )
        )


recommendationAspectsSearchDecoder : Decoder RecommendationAspectsSearch
recommendationAspectsSearchDecoder =
    map
        RecommendationAspectsSearch
        (maybe
            (field
                "id"
                string
            )
        )


recommendationDetailDecoder : Decoder RecommendationDetail
recommendationDetailDecoder =
    map6
        RecommendationDetail
        (field
            "summary"
            string
        )
        (field
            "highlights"
            paragraphs
        )
        (field
            "author"
            string
        )
        (field
            "date"
            string
        )
        (field
            "score"
            int
        )
        (maybe
            (field
                "id"
                string
            )
        )


recommendationPhotoSearchDecoder : Decoder RecommendationPhotoSearch
recommendationPhotoSearchDecoder =
    map
        RecommendationPhotoSearch
        (maybe
            (field
                "id"
                string
            )
        )


recommendationPhotoDecoder : Decoder RecommendationPhoto
recommendationPhotoDecoder =
    map2
        RecommendationPhoto
        (field
            "description"
            string
        )
        (maybe
            (field
                "id"
                string
            )
        )


locationsDecoder : Decoder Locations
locationsDecoder =
    list
        locationDecoder


categoriesDecoder : Decoder Categories
categoriesDecoder =
    list
        categoryDecoder


recommendationSearchResultsDecoder : Decoder RecommendationSearchResults
recommendationSearchResultsDecoder =
    list
        recommendationSummaryDecoder


recommendationPhotosDecoder : Decoder RecommendationPhotos
recommendationPhotosDecoder =
    list
        recommendationPhotoDecoder


categoryOptionsDecoder : Decoder CategoryOptions
categoryOptionsDecoder =
    list
        categoryOptionDecoder


recommendationAspectsDecoder : Decoder RecommendationAspects
recommendationAspectsDecoder =
    list
        recommendationAspectDecoder


rolesDecoder : Decoder Roles
rolesDecoder =
    list
        string


sessionDecoder : Decoder Session
sessionDecoder =
    map
        Session
        (field
            "roles"
            rolesDecoder
        )
