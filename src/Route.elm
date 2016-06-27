module Route exposing (..)

import Html.App as App
import Html exposing (..)
import Html.Attributes exposing (..)
import String exposing (split)
import Navigation


type Location
    = Home
    | Topics


type alias Model =
    Maybe Location


init : Maybe Location -> Model
init location =
    location



-- UTIL


urlFor : Location -> String
urlFor loc =
    let
        url =
            case loc of
                Home ->
                    "/"

                Topics ->
                    "/topics/"
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

            _ ->
                Nothing



-- VIEW


notfound : Html a
notfound =
    div [] [ text "Not found!" ]


navItem : Model -> Location -> String -> Html a
navItem model page caption =
    let
        active =
            case model of
                Nothing ->
                    False

                Just current ->
                    current == page
    in
        li []
            [ a [ href (urlFor page) ] [ text caption ]
            ]
