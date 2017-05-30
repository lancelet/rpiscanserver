{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Control.Applicative
import           Snap.Core
import           Snap.Util.FileServe
import           Snap.Http.Server

main :: IO ()
main = quickHttpServe site

site :: Snap ()
site =
    ifTop (writeBS "hello world") <|>
    route [ ("foo", writeBS "bar")
          , ("echo/:echoparam", echoHandler)
          , ("cam", camHandler)
          ] <|>
    dir "static" (serveDirectory ".")

echoHandler :: Snap ()
echoHandler = do
    param <- getParam "echoparam"
    maybe (writeBS "must specify echo/param in URL")
          writeBS param

camHandler :: Snap ()
camHandler = do
  xPosM <- getQueryParam "x"
  tPosM <- getQueryParam "theta"
  let
    xPos = maybe "0" id xPosM
    tPos = maybe "0" id tPosM
  writeBS "x = "
  writeBS xPos
  writeBS "\n"
  writeBS "theta = "
  writeBS tPos
  writeBS "\n"
