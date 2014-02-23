{-# LANGUAGE OverloadedStrings #-}

module Keys where

import Network.OAuth.OAuth2

-- | oauthCallback = Just "https://developers.google.com/oauthplayground"
googleKey :: OAuth2
googleKey = OAuth2 { oauthClientId = "175610503879-20bknm2gf72q11eogl4872to2romhhui.apps.googleusercontent.com"
                   , oauthClientSecret = "1wOQzIqvWC-2ISJInVmXtnXY"
                   , oauthCallback = Just "http://127.0.0.1:9988/googleCallback"
                   , oauthOAuthorizeEndpoint = "https://accounts.google.com/o/oauth2/auth"
                   , oauthAccessTokenEndpoint = "https://accounts.google.com/o/oauth2/token"
                   }