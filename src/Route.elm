module Route exposing (..)

import String exposing (split)
import Navigation
import Html exposing (Html, a, text)
import Html.Attributes exposing (href)
import Data


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

                Topic topicSlug ->
                    "/topics/" ++ topicSlug
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

            [ "topics", topicSlug ] ->
                Just (Topic topicSlug)

            _ ->
                Nothing


link : ( Location, String ) -> Html msg
link ( loc, label ) =
    a [ href <| urlFor loc ] [ text label ]
