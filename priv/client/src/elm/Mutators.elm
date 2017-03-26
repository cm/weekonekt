module Mutators exposing (..)

import Models exposing (..)
import Helpers exposing (..)


newCredentialsUsername : Text -> String -> Text
newCredentialsUsername oldV newV =
    newV


newCredentialsPassword : SecuredText -> String -> SecuredText
newCredentialsPassword oldV newV =
    newV


newCredentialsRememberMe : Maybe Boolean -> String -> Boolean
newCredentialsRememberMe oldV newV =
    stringToBool
        newV


newIdentityFirstName : Text -> String -> Text
newIdentityFirstName oldV newV =
    newV


newIdentityLastName : Text -> String -> Text
newIdentityLastName oldV newV =
    newV


newIdentityUsername : Text -> String -> Text
newIdentityUsername oldV newV =
    newV


newIdentityEmail : EmailAddress -> String -> EmailAddress
newIdentityEmail oldV newV =
    newV


newIdentityPreferredLanguage : Maybe Language -> String -> Language
newIdentityPreferredLanguage oldV newV =
    newV


newIdentityCountry : Country -> String -> Country
newIdentityCountry oldV newV =
    newV


newInfoMessageTitle : Heading -> String -> Heading
newInfoMessageTitle oldV newV =
    newV


newInfoMessageDescription : Paragraph -> String -> Paragraph
newInfoMessageDescription oldV newV =
    newV


newInfoMessageLevel : Severity -> String -> Severity
newInfoMessageLevel oldV newV =
    newV


newPasswordRecoveryEmail : EmailAddress -> String -> EmailAddress
newPasswordRecoveryEmail oldV newV =
    newV


newInfoName : Text -> String -> Text
newInfoName oldV newV =
    newV


newInfoVersion : Text -> String -> Text
newInfoVersion oldV newV =
    newV


newInfoDatabase : Boolean -> String -> Boolean
newInfoDatabase oldV newV =
    stringToBool
        newV


newLocationIcon : Icon -> String -> Icon
newLocationIcon oldV newV =
    newV


newLocationArea : Text -> String -> Text
newLocationArea oldV newV =
    newV


newLocationRegion : Text -> String -> Text
newLocationRegion oldV newV =
    newV


newLocationCountry : Text -> String -> Text
newLocationCountry oldV newV =
    newV


newCategoryIcon : Icon -> String -> Icon
newCategoryIcon oldV newV =
    newV


newCategoryName : Text -> String -> Text
newCategoryName oldV newV =
    newV


newCategoryDescription : Text -> String -> Text
newCategoryDescription oldV newV =
    newV


newCategoryOptionIcon : Icon -> String -> Icon
newCategoryOptionIcon oldV newV =
    newV


newCategoryOptionAspect : Label -> String -> Label
newCategoryOptionAspect oldV newV =
    newV


newCategoryOptionChoices : Choices -> Id -> Choices
newCategoryOptionChoices oldV newV =
    { oldV
        | selected = newV
    }


newLocationSearchKeywords : Text -> String -> Text
newLocationSearchKeywords oldV newV =
    newV


newCategoryOptionsSearchKeywords : Text -> String -> Text
newCategoryOptionsSearchKeywords oldV newV =
    newV


newRecommendationSummarySummary : Text -> String -> Text
newRecommendationSummarySummary oldV newV =
    newV


newRecommendationSummaryHighlights : Paragraphs -> Paragraphs -> Paragraphs
newRecommendationSummaryHighlights oldV newV =
    newV


newRecommendationAspectTitle : Heading -> String -> Heading
newRecommendationAspectTitle oldV newV =
    newV


newRecommendationAspectContents : Paragraphs -> Paragraphs -> Paragraphs
newRecommendationAspectContents oldV newV =
    newV


newRecommendationDetailSummary : Text -> String -> Text
newRecommendationDetailSummary oldV newV =
    newV


newRecommendationDetailHighlights : Paragraphs -> Paragraphs -> Paragraphs
newRecommendationDetailHighlights oldV newV =
    newV


newRecommendationDetailAuthor : Text -> String -> Text
newRecommendationDetailAuthor oldV newV =
    newV


newRecommendationDetailDate : Datetime -> String -> Datetime
newRecommendationDetailDate oldV newV =
    newV


newRecommendationDetailScore : Integer -> String -> Integer
newRecommendationDetailScore oldV newV =
    Result.withDefault
        0
        (String.toInt
            newV
        )


newRecommendationPhotoDescription : Text -> String -> Text
newRecommendationPhotoDescription oldV newV =
    newV
