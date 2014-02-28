{-# LANGUAGE OverloadedStrings #-}

module OAuth where

import 				Network.OAuth.OAuth2
import 				Keys (googleKey)
import 				Data.Aeson (FromJSON)
import qualified 	Data.ByteString.Lazy.Internal   as BL

authUrl :: URI
authUrl = authorizationUrl googleKey `appendQueryParam` googleScopeUserInfo

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

--data Token = Token { issuedTo      :: Text
--                   , audience       :: Text
--                   , userId        :: Maybe Text
--                   , scope          :: Text
--                   , expiresIn     :: Integer
--                   -- , email          :: Maybe Text
--                   -- , verified_email :: Maybe Bool
--                   , accessType    :: Text
--                   } deriving (Show)


--data User = User { id          :: Text
--                 , name        :: Text
--                 , givenName  :: Text
--                 , familyName :: Text
--                 , link        :: Text
--                 , picture     :: Text
--                 , gender      :: Text
--                 , birthday    :: Text
--                 , locale      :: Text
--                 } deriving (Show)
