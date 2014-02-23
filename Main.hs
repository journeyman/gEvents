{-# LANGUAGE OverloadedStrings #-}

{-

This is basically very manual test. Check following link for details.

Google web oauth: https://developers.google.com/accounts/docs/OAuth2WebServer

Google OAuth 2.0 playround: https://developers.google.com/oauthplayground/

-}

module Main where

import           Keys                            (googleKey)
import           Browsers                        (openUrl)
import           Network.OAuth.OAuth2

import           Network                         (withSocketsDo)
import           Data.Aeson                      (FromJSON)

import qualified Data.ByteString.Char8           as BS
import qualified Data.ByteString.Lazy.Internal   as BL
import           Data.Text                       (Text)                       

import           Prelude                         hiding (id)
import qualified Prelude                         as P (id)

--------------------------------------------------

data Token = Token { issuedTo      :: Text
                   , audience       :: Text
                   , userId        :: Maybe Text
                   , scope          :: Text
                   , expiresIn     :: Integer
                   -- , email          :: Maybe Text
                   -- , verified_email :: Maybe Bool
                   , accessType    :: Text
                   } deriving (Show)


data User = User { id          :: Text
                 , name        :: Text
                 , givenName  :: Text
                 , familyName :: Text
                 , link        :: Text
                 , picture     :: Text
                 , gender      :: Text
                 , birthday    :: Text
                 , locale      :: Text
                 } deriving (Show)


--------------------------------------------------

main :: IO ()
main = normalCase

authUrl :: URI
authUrl = authorizationUrl googleKey `appendQueryParam` googleScopeUserInfo

normalCase :: IO ()
normalCase = do
    BS.putStrLn authUrl
    putStrLn "visit the url and paste code here: "
    openUrl $ BS.unpack authUrl
    code <- fmap BS.pack getLine
    --let code = BS.pack "4/oIBdE9kQxTSKbvChREag0i8P1d5f.IpgFb49PuGEXPvB8fYmgkJztS6NOhwI"
    putStrLn $ "code is: " ++ (BS.unpack code)
    --withSocketsDo is needed to fix http://stackoverflow.com/questions/19159686/internalioexception-getaddrinfo-does-not-exist-error-10093-on-windows-8
    (Right token) <- withSocketsDo $ fetchAccessToken googleKey code
    putStr "AccessToken: " >> print token
    -- get response in ByteString
    validateToken token >>= print
    -- get response in JSON
    --(validateToken' token :: IO (OAuth2Result Token)) >>= print
    -- get response in ByteString
    userinfo token >>= print
    -- get response in JSON
    --(userinfo' token :: IO (OAuth2Result User)) >>= print

--------------------------------------------------
-- Google API

-- | This is special for google Gain read-only access to the user's email address.
googleScopeEmail :: QueryParams
googleScopeEmail = [("scope", "https://www.googleapis.com/auth/userinfo.email")]

-- | Gain read-only access to basic profile information, including a
googleScopeUserInfo :: QueryParams
googleScopeUserInfo = [("scope", "https://www.googleapis.com/auth/userinfo.profile")]

googleResponseType :: QueryParams
googleResponseType = [("response_type", "code")]

-- | Access offline
googleAccessOffline :: QueryParams
googleAccessOffline = [("access_type", "offline")
                      ,("approval_prompt", "force")]

-- | Token Validation
validateToken :: AccessToken -> IO (OAuth2Result BL.ByteString)
validateToken token = authGetBS token "https://www.googleapis.com/oauth2/v1/tokeninfo"

validateToken' :: FromJSON a => AccessToken -> IO (OAuth2Result a)
validateToken' token = authGetJSON token "https://www.googleapis.com/oauth2/v1/tokeninfo"

-- | fetch user email.
--   for more information, please check the playround site.
--
userinfo :: AccessToken -> IO (OAuth2Result BL.ByteString)
userinfo token = authGetBS token "https://www.googleapis.com/oauth2/v2/userinfo"

userinfo' :: FromJSON a => AccessToken -> IO (OAuth2Result a)
userinfo' token = authGetJSON token "https://www.googleapis.com/oauth2/v2/userinfo"
