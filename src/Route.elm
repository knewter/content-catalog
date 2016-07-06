module Route exposing (..)

import String exposing (split)
import Navigation


type Location
    = Home
    | Topics
    | Topic String


type alias Model =
    Maybe Location


init : Maybe Location -> Model
init location =
    location


urlFor : Location -> String
urlFor loc =
    let
        url =
            case loc of
                Home ->
                    "/"

                Topics ->
                    "/topics"

                Topic slug ->
                    "/topics/" ++ slug
    in
        "#" ++ url


locFor : Navigation.Location -> Maybe Location
locFor path =
    let
        segments =
            path.hash
                |> split "/"
                |> List.filter (\seg -> seg /= "" && seg /= "#")
    in
        case segments of
            [] ->
                Just Home

            [ "topics" ] ->
                Just Topics

            [ "topics", slug ] ->
                Just (Topic slug)

            _ ->
                Nothing
