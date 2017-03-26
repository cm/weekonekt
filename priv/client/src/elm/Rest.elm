module Rest exposing (..)

import Json.Decode exposing (Decoder)
import Http exposing (request, send, Body, jsonBody, emptyBody, expectJson, Error, Header, header)


emptyHeaders : List Header
emptyHeaders =
    []


get : String -> Decoder a -> (Result Error a -> msg) -> Cmd msg
get url decoder msg =
    request
        { method = "GET"
        , headers = emptyHeaders
        , url = url
        , body = emptyBody
        , expect =
            (expectJson
                decoder
            )
        , timeout = Nothing
        , withCredentials = False
        }
        |> send
            msg


post : String -> Body -> Decoder a -> (Result Error a -> msg) -> Cmd msg
post url body decoder msg =
    request
        { method = "POST"
        , headers = emptyHeaders
        , url = url
        , body = body
        , expect =
            (expectJson
                decoder
            )
        , timeout = Nothing
        , withCredentials = False
        }
        |> send
            msg


put : String -> Body -> Decoder a -> (Result Error a -> msg) -> Cmd msg
put url body decoder msg =
    request
        { method = "POST"
        , headers = emptyHeaders
        , url = url
        , body = body
        , expect =
            (expectJson
                decoder
            )
        , timeout = Nothing
        , withCredentials = False
        }
        |> send
            msg


delete : String -> Decoder a -> (Result Error a -> msg) -> Cmd msg
delete url decoder msg =
    request
        { method = "GET"
        , headers = emptyHeaders
        , url = url
        , body = emptyBody
        , expect =
            (expectJson
                decoder
            )
        , timeout = Nothing
        , withCredentials = False
        }
        |> send
            msg
