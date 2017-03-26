module Finders exposing (..)

import Models exposing (..)


findLocation : Id -> Locations -> Maybe Location
findLocation id locations =
    List.filter
        (\l ->
            id
                == l.id
        )
        locations
        |> List.head


findCategory : Id -> Categories -> Maybe Category
findCategory id categories =
    List.filter
        (\c ->
            id
                == c.id
        )
        categories
        |> List.head


findRecommendationSummary : Id -> RecommendationSearchResults -> Maybe RecommendationSummary
findRecommendationSummary id recommendationSearchResults =
    List.filter
        (\rs ->
            id
                == rs.id
        )
        recommendationSearchResults
        |> List.head


findRecommendationPhoto : Id -> RecommendationPhotos -> Maybe RecommendationPhoto
findRecommendationPhoto id recommendationPhotos =
    List.filter
        (\rp ->
            id
                == rp.id
        )
        recommendationPhotos
        |> List.head


findCategoryOption : Id -> CategoryOptions -> Maybe CategoryOption
findCategoryOption id categoryOptions =
    List.filter
        (\co ->
            id
                == co.id
        )
        categoryOptions
        |> List.head


findRecommendationAspect : Id -> RecommendationAspects -> Maybe RecommendationAspect
findRecommendationAspect id recommendationAspects =
    List.filter
        (\ra ->
            id
                == ra.id
        )
        recommendationAspects
        |> List.head
