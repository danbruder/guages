module Pages.Top exposing (Model, Msg, Params, page)

import Browser.Navigation exposing (Key)
import Css.Global
import Dict exposing (Dict)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href, src, style, type_, value)
import Html.Styled.Events exposing (..)
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route
import Spa.Page as Page exposing (Page)
import Spa.Url as Url exposing (Url)
import Tailwind.Breakpoints exposing (..)
import Tailwind.Utilities exposing (..)


page : Page Params Model Msg
page =
    Page.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Params =
    ()


type alias Model =
    {}


init : Url Params -> ( Model, Cmd Msg )
init _ =
    ( {}
    , Cmd.none
    )



-- UPDATE


type Msg
    = Noop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Top"
    , body =
        [ body model
        ]
    }


body model =
    div []
        [ Css.Global.global globalStyles
        , p
            [ css
                [ flex
                , uppercase
                , text_gray_700
                , text_sm
                , p_3
                , font_bold
                , bg_gray_100
                , border_b
                , border_gray_300
                ]
            ]
            [ text "Guages By Paul Bruder" ]
        , div
            [ css
                [ w_full
                , flex
                , items_center
                , p_4
                , justify_center
                , relative
                ]
            ]
            [ viewGauge model
            ]
        ]


viewGauge model =
    div [ style "width" "799px" ]
        [ div [ css [ absolute, w_full ] ] [ img [ src "/img/gauge.png" ] [] ]
        , div [ css [ absolute, w_full, flex, justify_center, items_center ], style "top" "202px", style "left" "11px" ]
            [ div [ style "width" "55px" ] [ img [ src "/img/arrow.png" ] [] ]
            ]
        ]
