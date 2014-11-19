module Settings.StaticFiles where

import Prelude (IO)
import Yesod.Static
import qualified Yesod.Static as Static
import Settings
import Language.Haskell.TH (Q, Exp, Name)
import Data.Default (def)

-- | use this to create your static file serving site
staticSite :: AppSettings -> IO Static.Static
staticSite settings =
    (if appMutableStatic settings then Static.staticDevel else Static.static)
    (appStaticDir settings)

-- | This generates easy references to files in the static directory at compile time,
--   giving you compile-time verification that referenced files exist.
--   Warning: any files added to your static directory during run-time can't be
--   accessed this way. You'll have to use their FilePath or URL to access them.
$(staticFiles (appStaticDir compileTimeAppSettings))

combineSettings :: CombineSettings
combineSettings = def

-- The following two functions can be used to combine multiple CSS or JS files
-- at compile time to decrease the number of http requests.
-- Sample usage (inside a Widget):
--
-- > $(combineStylesheets 'StaticR [style1_css, style2_css])

combineStylesheets :: Name -> [Route Static] -> Q Exp
combineStylesheets = combineStylesheets'
    (appSkipCombining compileTimeAppSettings)
    combineSettings

combineScripts :: Name -> [Route Static] -> Q Exp
combineScripts = combineScripts'
    (appSkipCombining compileTimeAppSettings)
    combineSettings
