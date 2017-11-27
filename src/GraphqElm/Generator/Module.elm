module GraphqElm.Generator.Module exposing (..)

import GraphqElm.Generator.Query as Query
import GraphqElm.Parser.Type as Type exposing (Type)


prepend : String
prepend =
    """module Api.Query exposing (..)

import GraphqElm.Argument as Argument exposing (Argument)
import GraphqElm.Field as Field exposing (Field, FieldDecoder)
import GraphqElm.Object as Object exposing (Object)
import GraphqElm.TypeLock exposing (TypeLocked(TypeLocked))
import Json.Decode as Decode exposing (Decoder)


"""


generate : List { name : String, typeOf : Type } -> String
generate fields =
    prepend
        ++ (List.map Query.generate fields |> String.join "\n\n")