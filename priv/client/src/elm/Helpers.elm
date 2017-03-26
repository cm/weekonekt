module Helpers exposing (..)

import Models exposing (..)
import Messages exposing (..)


sameIds : Id -> Id -> Bool
sameIds id1 id2 =
    id1
        == id2


ifSameIds : Id -> Id -> String -> String
ifSameIds id1 id2 str =
    case
        sameIds
            id1
            id2
    of
        True ->
            str

        False ->
            ""


isTrue : Bool -> Bool
isTrue v =
    v
        == True


isFalse : Bool -> Bool
isFalse v =
    v
        == False


stringToBool : String -> Bool
stringToBool v =
    case
        v
    of
        "True" ->
            True

        "true" ->
            True

        "1" ->
            True

        _ ->
            False


allTrue : List Bool -> Bool
allTrue values =
    List.isEmpty
        (List.filter
            isFalse
            values
        )


newError : String -> String -> Error
newError summary description =
    { summary = summary
    , description = description
    }


noTransitionError : Model -> ( Model, Cmd Msg )
noTransitionError model =
    error
        model
        "Error in configuration"
        "No matching transition found. None of the previous conditions where matched, and no default transition was defined."


error : Model -> String -> String -> ( Model, Cmd Msg )
error model summary description =
    ( { model
        | page =
            ErrorPage
        , error =
            Just
                (newError
                    summary
                    description
                )
      }
    , Cmd.none
    )


isEmptyList : Maybe (List a) -> Bool
isEmptyList aList =
    case
        aList
    of
        Nothing ->
            True

        Just l ->
            List.isEmpty
                l


textToString : Text -> String
textToString v =
    v


securedTextToString : SecuredText -> String
securedTextToString v =
    "Not shown"


integerToString : Integer -> String
integerToString v =
    (toString
        v
    )


decimalToString : Decimal -> String
decimalToString v =
    (toString
        v
    )


booleanToString : Boolean -> String
booleanToString v =
    (toString
        v
    )


datetimeToString : Datetime -> String
datetimeToString v =
    (toString
        v
    )


currencyToString : Currency -> String
currencyToString v =
    v


emailAddressToString : EmailAddress -> String
emailAddressToString v =
    v


languageToString : Language -> String
languageToString v =
    v


phoneNumberToString : PhoneNumber -> String
phoneNumberToString v =
    v


countryToString : Country -> String
countryToString v =
    v


cityToString : City -> String
cityToString v =
    v


zipCodeToString : ZipCode -> String
zipCodeToString v =
    v


linkToString : Link -> String
linkToString v =
    v


headingToString : Heading -> String
headingToString v =
    v


quoteToString : Quote -> String
quoteToString v =
    v


paragraphToString : Paragraph -> String
paragraphToString v =
    v


severityToString : Severity -> String
severityToString v =
    v


iconToString : Icon -> String
iconToString v =
    v


labelToString : Label -> String
labelToString v =
    v


replaceLocation : Locations -> Location -> Locations
replaceLocation col item =
    List.map
        (\i ->
            case
                i.id
                    == item.id
            of
                True ->
                    item

                False ->
                    i
        )
        col


replaceCategory : Categories -> Category -> Categories
replaceCategory col item =
    List.map
        (\i ->
            case
                i.id
                    == item.id
            of
                True ->
                    item

                False ->
                    i
        )
        col


replaceRecommendationSummary : RecommendationSearchResults -> RecommendationSummary -> RecommendationSearchResults
replaceRecommendationSummary col item =
    List.map
        (\i ->
            case
                i.id
                    == item.id
            of
                True ->
                    item

                False ->
                    i
        )
        col


replaceRecommendationPhoto : RecommendationPhotos -> RecommendationPhoto -> RecommendationPhotos
replaceRecommendationPhoto col item =
    List.map
        (\i ->
            case
                i.id
                    == item.id
            of
                True ->
                    item

                False ->
                    i
        )
        col


replaceCategoryOption : CategoryOptions -> CategoryOption -> CategoryOptions
replaceCategoryOption col item =
    List.map
        (\i ->
            case
                i.id
                    == item.id
            of
                True ->
                    item

                False ->
                    i
        )
        col


replaceRecommendationAspect : RecommendationAspects -> RecommendationAspect -> RecommendationAspects
replaceRecommendationAspect col item =
    List.map
        (\i ->
            case
                i.id
                    == item.id
            of
                True ->
                    item

                False ->
                    i
        )
        col
