module Main
       ( main
       ) where

import Gauge.Main (bench, bgroup, defaultMain, nf)

import qualified Benchmark.Htoml as Htoml
import qualified Benchmark.HtomlMegaparsec as HtomlM
import qualified Benchmark.Tomland as Tomland
import qualified Benchmark.TomlParser as TomlParser
import qualified Data.Text.IO as TIO


-- | Benchmark.
main :: IO ()
main = do
    txt <- TIO.readFile "./benchmark/benchmark.toml"
    Right tomlandVal <- pure $ Tomland.parse txt
    Right htomlVal <- pure $ Htoml.parse txt
    Right htomlMegaVal <- pure $ HtomlM.parse txt
    Right tomlParserVal <- pure $ TomlParser.parse txt
    defaultMain
        [ bgroup "Parse"
            [ bench "tomland"          $ nf Tomland.parse txt
            , bench "htoml"            $ nf Htoml.parse txt
            , bench "htoml-megaparsec" $ nf HtomlM.parse txt
            , bench "toml-parser"      $ nf TomlParser.parse txt
            ]
        , bgroup "Convert"
            [ bench "tomland"          $ nf Tomland.convert tomlandVal
            , bench "htoml"            $ nf Htoml.convert htomlVal
            , bench "htoml-megaparsec" $ nf HtomlM.convert htomlMegaVal
            , bench "toml-parser"      $ nf TomlParser.convert tomlParserVal
            ]
        , bgroup "Decode"
            [ bench "tomland"          $ nf Tomland.decode txt
            , bench "htoml"            $ nf Htoml.decode txt
            , bench "htoml-megaparsec" $ nf HtomlM.decode txt
            , bench "toml-parser"      $ nf TomlParser.decode txt
            ]
        ]
