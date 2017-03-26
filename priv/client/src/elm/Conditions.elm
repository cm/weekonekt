module Conditions exposing (..)

import Models exposing (..)


sessionRolesContainsVisitor : Model -> Bool
sessionRolesContainsVisitor model =
    case
        model.session
    of
        Nothing ->
            False

        Just s ->
            case
                s.roles
            of
                r ->
                    List.member
                        "Visitor"
                        r


sessionRolesDoesNotContainVisitor : Model -> Bool
sessionRolesDoesNotContainVisitor model =
    case
        model.session
    of
        Nothing ->
            False

        Just s ->
            case
                s.roles
            of
                r ->
                    not
                        (List.member
                            "Visitor"
                            r
                        )
