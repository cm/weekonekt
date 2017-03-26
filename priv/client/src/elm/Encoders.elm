module Encoders exposing (..)

import Json.Encode exposing (Value, bool, object, float, null, int, string, list)
import Models exposing (..)


encodeId : Id -> Value
encodeId id =
    encodeOptionalText
        id


encodeChoices : Choices -> Value
encodeChoices value =
    object
        [ ( "selected"
          , (encodeId
                value.selected
            )
          )
        ]


encodeParagraphs : Paragraphs -> Value
encodeParagraphs value =
    list
        (List.map
            (\v ->
                string
                    v
            )
            value
        )


encodeOptionalText : Maybe Text -> Value
encodeOptionalText value =
    case
        value
    of
        Nothing ->
            null

        Just v ->
            encodeText
                v


encodeText : Text -> Value
encodeText value =
    string
        value


encodeOptionalSecuredText : Maybe SecuredText -> Value
encodeOptionalSecuredText value =
    case
        value
    of
        Nothing ->
            null

        Just v ->
            encodeSecuredText
                v


encodeSecuredText : SecuredText -> Value
encodeSecuredText value =
    string
        value


encodeOptionalInteger : Maybe Integer -> Value
encodeOptionalInteger value =
    case
        value
    of
        Nothing ->
            null

        Just v ->
            encodeInteger
                v


encodeInteger : Integer -> Value
encodeInteger value =
    int
        value


encodeOptionalDecimal : Maybe Decimal -> Value
encodeOptionalDecimal value =
    case
        value
    of
        Nothing ->
            null

        Just v ->
            encodeDecimal
                v


encodeDecimal : Decimal -> Value
encodeDecimal value =
    float
        value


encodeOptionalBoolean : Maybe Boolean -> Value
encodeOptionalBoolean value =
    case
        value
    of
        Nothing ->
            null

        Just v ->
            encodeBoolean
                v


encodeBoolean : Boolean -> Value
encodeBoolean value =
    bool
        value


encodeOptionalDatetime : Maybe Datetime -> Value
encodeOptionalDatetime value =
    case
        value
    of
        Nothing ->
            null

        Just v ->
            encodeDatetime
                v


encodeDatetime : Datetime -> Value
encodeDatetime value =
    string
        value


encodeOptionalCurrency : Maybe Currency -> Value
encodeOptionalCurrency value =
    case
        value
    of
        Nothing ->
            null

        Just v ->
            encodeCurrency
                v


encodeCurrency : Currency -> Value
encodeCurrency value =
    string
        value


encodeOptionalEmailAddress : Maybe EmailAddress -> Value
encodeOptionalEmailAddress value =
    case
        value
    of
        Nothing ->
            null

        Just v ->
            encodeEmailAddress
                v


encodeEmailAddress : EmailAddress -> Value
encodeEmailAddress value =
    string
        value


encodeOptionalLanguage : Maybe Language -> Value
encodeOptionalLanguage value =
    case
        value
    of
        Nothing ->
            null

        Just v ->
            encodeLanguage
                v


encodeLanguage : Language -> Value
encodeLanguage value =
    string
        value


encodeOptionalPhoneNumber : Maybe PhoneNumber -> Value
encodeOptionalPhoneNumber value =
    case
        value
    of
        Nothing ->
            null

        Just v ->
            encodePhoneNumber
                v


encodePhoneNumber : PhoneNumber -> Value
encodePhoneNumber value =
    string
        value


encodeOptionalCountry : Maybe Country -> Value
encodeOptionalCountry value =
    case
        value
    of
        Nothing ->
            null

        Just v ->
            encodeCountry
                v


encodeCountry : Country -> Value
encodeCountry value =
    string
        value


encodeOptionalCity : Maybe City -> Value
encodeOptionalCity value =
    case
        value
    of
        Nothing ->
            null

        Just v ->
            encodeCity
                v


encodeCity : City -> Value
encodeCity value =
    string
        value


encodeOptionalZipCode : Maybe ZipCode -> Value
encodeOptionalZipCode value =
    case
        value
    of
        Nothing ->
            null

        Just v ->
            encodeZipCode
                v


encodeZipCode : ZipCode -> Value
encodeZipCode value =
    string
        value


encodeOptionalLink : Maybe Link -> Value
encodeOptionalLink value =
    case
        value
    of
        Nothing ->
            null

        Just v ->
            encodeLink
                v


encodeLink : Link -> Value
encodeLink value =
    string
        value


encodeOptionalHeading : Maybe Heading -> Value
encodeOptionalHeading value =
    case
        value
    of
        Nothing ->
            null

        Just v ->
            encodeHeading
                v


encodeHeading : Heading -> Value
encodeHeading value =
    string
        value


encodeOptionalQuote : Maybe Quote -> Value
encodeOptionalQuote value =
    case
        value
    of
        Nothing ->
            null

        Just v ->
            encodeQuote
                v


encodeQuote : Quote -> Value
encodeQuote value =
    string
        value


encodeOptionalParagraph : Maybe Paragraph -> Value
encodeOptionalParagraph value =
    case
        value
    of
        Nothing ->
            null

        Just v ->
            encodeParagraph
                v


encodeParagraph : Paragraph -> Value
encodeParagraph value =
    string
        value


encodeOptionalSeverity : Maybe Severity -> Value
encodeOptionalSeverity value =
    case
        value
    of
        Nothing ->
            null

        Just v ->
            encodeSeverity
                v


encodeSeverity : Severity -> Value
encodeSeverity value =
    string
        value


encodeOptionalIcon : Maybe Icon -> Value
encodeOptionalIcon value =
    case
        value
    of
        Nothing ->
            null

        Just v ->
            encodeIcon
                v


encodeIcon : Icon -> Value
encodeIcon value =
    string
        value


encodeOptionalLabel : Maybe Label -> Value
encodeOptionalLabel value =
    case
        value
    of
        Nothing ->
            null

        Just v ->
            encodeLabel
                v


encodeLabel : Label -> Value
encodeLabel value =
    string
        value


encodeCredentialsAsContext : Credentials -> Value
encodeCredentialsAsContext c =
    object
        [ ( "id"
          , encodeId
                c.id
          )
        ]


encodeCredentials : Credentials -> Value
encodeCredentials c =
    object
        [ ( "username"
          , encodeText
                c.username
          )
        , ( "password"
          , encodeSecuredText
                c.password
          )
        , ( "rememberMe"
          , encodeOptionalBoolean
                c.rememberMe
          )
        ]


encodeIdentityAsContext : Identity -> Value
encodeIdentityAsContext i =
    object
        [ ( "id"
          , encodeId
                i.id
          )
        ]


encodeIdentity : Identity -> Value
encodeIdentity i =
    object
        [ ( "firstName"
          , encodeText
                i.firstName
          )
        , ( "lastName"
          , encodeText
                i.lastName
          )
        , ( "username"
          , encodeText
                i.username
          )
        , ( "email"
          , encodeEmailAddress
                i.email
          )
        , ( "preferredLanguage"
          , encodeOptionalLanguage
                i.preferredLanguage
          )
        , ( "country"
          , encodeCountry
                i.country
          )
        ]


encodeInfoMessageAsContext : InfoMessage -> Value
encodeInfoMessageAsContext im =
    object
        [ ( "id"
          , encodeId
                im.id
          )
        ]


encodeInfoMessage : InfoMessage -> Value
encodeInfoMessage im =
    object
        [ ( "title"
          , encodeHeading
                im.title
          )
        , ( "description"
          , encodeParagraph
                im.description
          )
        , ( "level"
          , encodeSeverity
                im.level
          )
        ]


encodePasswordRecoveryAsContext : PasswordRecovery -> Value
encodePasswordRecoveryAsContext pr =
    object
        [ ( "id"
          , encodeId
                pr.id
          )
        ]


encodePasswordRecovery : PasswordRecovery -> Value
encodePasswordRecovery pr =
    object
        [ ( "email"
          , encodeEmailAddress
                pr.email
          )
        ]


encodeInfoAsContext : Info -> Value
encodeInfoAsContext i =
    object
        [ ( "id"
          , encodeId
                i.id
          )
        ]


encodeInfo : Info -> Value
encodeInfo i =
    object
        [ ( "name"
          , encodeText
                i.name
          )
        , ( "version"
          , encodeText
                i.version
          )
        , ( "database"
          , encodeBoolean
                i.database
          )
        ]


encodeRecommendationSearchAsContext : RecommendationSearch -> Value
encodeRecommendationSearchAsContext rs =
    object
        [ ( "id"
          , encodeId
                rs.id
          )
        ]


encodeRecommendationSearch : RecommendationSearch -> CategoryOptions -> Location -> Category -> Value
encodeRecommendationSearch rs co l c =
    object
        [ ( "categoryOptions"
          , encodeCategoryOptionsAsContext
                co
          )
        , ( "location"
          , encodeLocationAsContext
                l
          )
        , ( "category"
          , encodeCategoryAsContext
                c
          )
        ]


encodeLocationAsContext : Location -> Value
encodeLocationAsContext l =
    object
        [ ( "id"
          , encodeId
                l.id
          )
        ]


encodeLocation : Location -> Value
encodeLocation l =
    object
        [ ( "icon"
          , encodeIcon
                l.icon
          )
        , ( "area"
          , encodeText
                l.area
          )
        , ( "region"
          , encodeText
                l.region
          )
        , ( "country"
          , encodeText
                l.country
          )
        ]


encodeLocationsAsContext : Locations -> Value
encodeLocationsAsContext l =
    (List.map
        (\v ->
            encodeLocationAsContext
                v
        )
        l
    )
        |> list


encodeLocations : Locations -> Value
encodeLocations l =
    object
        []


encodeCategoryAsContext : Category -> Value
encodeCategoryAsContext c =
    object
        [ ( "id"
          , encodeId
                c.id
          )
        ]


encodeCategory : Category -> Value
encodeCategory c =
    object
        [ ( "icon"
          , encodeIcon
                c.icon
          )
        , ( "name"
          , encodeText
                c.name
          )
        , ( "description"
          , encodeText
                c.description
          )
        ]


encodeCategoriesAsContext : Categories -> Value
encodeCategoriesAsContext c =
    (List.map
        (\v ->
            encodeCategoryAsContext
                v
        )
        c
    )
        |> list


encodeCategories : Categories -> Value
encodeCategories c =
    object
        []


encodeCategoryOptionAsContext : CategoryOption -> Value
encodeCategoryOptionAsContext co =
    object
        [ ( "choices"
          , encodeChoices
                co.choices
          )
        , ( "id"
          , encodeId
                co.id
          )
        ]


encodeCategoryOption : CategoryOption -> Value
encodeCategoryOption co =
    object
        [ ( "icon"
          , encodeIcon
                co.icon
          )
        , ( "aspect"
          , encodeLabel
                co.aspect
          )
        , ( "choices"
          , encodeChoices
                co.choices
          )
        ]


encodeLocationSearchAsContext : LocationSearch -> Value
encodeLocationSearchAsContext ls =
    object
        [ ( "id"
          , encodeId
                ls.id
          )
        ]


encodeLocationSearch : LocationSearch -> Value
encodeLocationSearch ls =
    object
        [ ( "keywords"
          , encodeText
                ls.keywords
          )
        ]


encodeRecommendationSearchResultsAsContext : RecommendationSearchResults -> Value
encodeRecommendationSearchResultsAsContext rsr =
    (List.map
        (\v ->
            encodeRecommendationSummaryAsContext
                v
        )
        rsr
    )
        |> list


encodeRecommendationSearchResults : RecommendationSearchResults -> Value
encodeRecommendationSearchResults rsr =
    object
        []


encodeRecommendationDetailSearchAsContext : RecommendationDetailSearch -> Value
encodeRecommendationDetailSearchAsContext rds =
    object
        [ ( "id"
          , encodeId
                rds.id
          )
        ]


encodeRecommendationDetailSearch : RecommendationDetailSearch -> RecommendationSummary -> Value
encodeRecommendationDetailSearch rds rs =
    object
        [ ( "recommendationSummary"
          , encodeRecommendationSummaryAsContext
                rs
          )
        ]


encodeRecommendationPhotosAsContext : RecommendationPhotos -> Value
encodeRecommendationPhotosAsContext rp =
    (List.map
        (\v ->
            encodeRecommendationPhotoAsContext
                v
        )
        rp
    )
        |> list


encodeRecommendationPhotos : RecommendationPhotos -> Value
encodeRecommendationPhotos rp =
    object
        []


encodeCategorySearchAsContext : CategorySearch -> Value
encodeCategorySearchAsContext cs =
    object
        [ ( "id"
          , encodeId
                cs.id
          )
        ]


encodeCategorySearch : CategorySearch -> Location -> Value
encodeCategorySearch cs l =
    object
        [ ( "location"
          , encodeLocationAsContext
                l
          )
        ]


encodeCategoryOptionsAsContext : CategoryOptions -> Value
encodeCategoryOptionsAsContext co =
    (List.map
        (\v ->
            encodeCategoryOptionAsContext
                v
        )
        co
    )
        |> list


encodeCategoryOptions : CategoryOptions -> Category -> Value
encodeCategoryOptions co c =
    object
        [ ( "category"
          , encodeCategoryAsContext
                c
          )
        ]


encodeCategoryOptionsSearchAsContext : CategoryOptionsSearch -> Value
encodeCategoryOptionsSearchAsContext cos =
    object
        [ ( "id"
          , encodeId
                cos.id
          )
        ]


encodeCategoryOptionsSearch : CategoryOptionsSearch -> Category -> Value
encodeCategoryOptionsSearch cos c =
    object
        [ ( "keywords"
          , encodeText
                cos.keywords
          )
        , ( "category"
          , encodeCategoryAsContext
                c
          )
        ]


encodeRecommendationSummaryAsContext : RecommendationSummary -> Value
encodeRecommendationSummaryAsContext rs =
    object
        [ ( "id"
          , encodeId
                rs.id
          )
        ]


encodeRecommendationSummary : RecommendationSummary -> Value
encodeRecommendationSummary rs =
    object
        [ ( "summary"
          , encodeText
                rs.summary
          )
        , ( "highlights"
          , encodeParagraphs
                rs.highlights
          )
        ]


encodeRecommendationRelatedSearchAsContext : RecommendationRelatedSearch -> Value
encodeRecommendationRelatedSearchAsContext rrs =
    object
        [ ( "id"
          , encodeId
                rrs.id
          )
        ]


encodeRecommendationRelatedSearch : RecommendationRelatedSearch -> RecommendationSummary -> Value
encodeRecommendationRelatedSearch rrs rs =
    object
        [ ( "recommendationSummary"
          , encodeRecommendationSummaryAsContext
                rs
          )
        ]


encodeRecommendationAspectAsContext : RecommendationAspect -> Value
encodeRecommendationAspectAsContext ra =
    object
        [ ( "id"
          , encodeId
                ra.id
          )
        ]


encodeRecommendationAspect : RecommendationAspect -> Value
encodeRecommendationAspect ra =
    object
        [ ( "title"
          , encodeHeading
                ra.title
          )
        , ( "contents"
          , encodeParagraphs
                ra.contents
          )
        ]


encodeRecommendationAspectsAsContext : RecommendationAspects -> Value
encodeRecommendationAspectsAsContext ra =
    (List.map
        (\v ->
            encodeRecommendationAspectAsContext
                v
        )
        ra
    )
        |> list


encodeRecommendationAspects : RecommendationAspects -> Value
encodeRecommendationAspects ra =
    object
        []


encodeRecommendationAspectsSearchAsContext : RecommendationAspectsSearch -> Value
encodeRecommendationAspectsSearchAsContext ras =
    object
        [ ( "id"
          , encodeId
                ras.id
          )
        ]


encodeRecommendationAspectsSearch : RecommendationAspectsSearch -> RecommendationSummary -> Value
encodeRecommendationAspectsSearch ras rs =
    object
        [ ( "recommendationSummary"
          , encodeRecommendationSummaryAsContext
                rs
          )
        ]


encodeRecommendationDetailAsContext : RecommendationDetail -> Value
encodeRecommendationDetailAsContext rd =
    object
        [ ( "id"
          , encodeId
                rd.id
          )
        ]


encodeRecommendationDetail : RecommendationDetail -> Value
encodeRecommendationDetail rd =
    object
        [ ( "summary"
          , encodeText
                rd.summary
          )
        , ( "highlights"
          , encodeParagraphs
                rd.highlights
          )
        , ( "author"
          , encodeText
                rd.author
          )
        , ( "date"
          , encodeDatetime
                rd.date
          )
        , ( "score"
          , encodeInteger
                rd.score
          )
        ]


encodeRecommendationPhotoSearchAsContext : RecommendationPhotoSearch -> Value
encodeRecommendationPhotoSearchAsContext rps =
    object
        [ ( "id"
          , encodeId
                rps.id
          )
        ]


encodeRecommendationPhotoSearch : RecommendationPhotoSearch -> RecommendationSummary -> Value
encodeRecommendationPhotoSearch rps rs =
    object
        [ ( "recommendationSummary"
          , encodeRecommendationSummaryAsContext
                rs
          )
        ]


encodeRecommendationPhotoAsContext : RecommendationPhoto -> Value
encodeRecommendationPhotoAsContext rp =
    object
        [ ( "id"
          , encodeId
                rp.id
          )
        ]


encodeRecommendationPhoto : RecommendationPhoto -> Value
encodeRecommendationPhoto rp =
    object
        [ ( "description"
          , encodeText
                rp.description
          )
        ]
