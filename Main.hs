{-# LANGUAGE OverloadedStrings #-}

{-

This is basically very manual test. Check following link for details.

Google web oauth: https://developers.google.com/accounts/docs/OAuth2WebServer

Google OAuth 2.0 playround: https://developers.google.com/oauthplayground/

-}

module Main where

import           Cache                           (saveAccessToken, tryGetAccessToken)
import           Browsers                        (openUrl)
import           OAuth
import           Network.OAuth.OAuth2
import           Keys (googleKey)

import           Network                         (withSocketsDo)
import qualified Data.ByteString.Char8           as BS
import qualified Data.ByteString.Lazy.Internal   as BL
import           Data.Text                       (Text)                       


main :: IO ()
main = normalCase

normalCase :: IO ()
normalCase = do
    putStrLn "opening oauth url..."
    putStrLn "visit the url and paste code here: "
    openUrl $ BS.unpack authUrl
    code <- fmap BS.pack getLine
    --let code = BS.pack "4/oIBdE9kQxTSKbvChREag0i8P1d5f.IpgFb49PuGEXPvB8fYmgkJztS6NOhwI"
    putStrLn $ "code is: " ++ BS.unpack code
    --withSocketsDo is needed to fix http://stackoverflow.com/questions/19159686/internalioexception-getaddrinfo-does-not-exist-error-10093-on-windows-8
    (Right token) <- withSocketsDo $ fetchAccessToken googleKey code
    putStr "AccessToken: " >> print token
    putStrLn "Saving token to cache"
    saveAccessToken token
    putStrLn "Successfully saved token to cache"
    -- get response in ByteString
    validateToken token >>= print
    -- get response in JSON
    --(validateToken' token :: IO (OAuth2Result Token)) >>= print
    -- get response in ByteString
    userinfo token >>= print
    -- get response in JSON
    --(userinfo' token :: IO (OAuth2Result User)) >>= print