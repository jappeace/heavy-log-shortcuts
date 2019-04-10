{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE RankNTypes                #-}

-- | Wraps the monad logger library
--   Bunch of aliases for heavy logger, simpler api
module System.Log.Heavy.Short
  ( run
  , discard
  , info
  , debug
  , warn
  , error
  , info0
  , debug0
  , warn0
  , error0
  , dump
  , lift
  ) where

import           Control.Monad.IO.Class
import           Control.Monad.Trans.Control
import           Data.Monoid                      ((<>))
import qualified Data.Text                        as Text
import           Data.Text.Format.Heavy.Instances (Single (..))
import qualified Data.Text.Lazy                   as Lazy
import           Prelude                          (Char, IO, ($))
import           System.Log.FastLogger            as FL
import           System.Log.Heavy
import           System.Log.Heavy.Format
import           System.Log.Heavy.LoggingT        (LoggingT)
import qualified System.Log.Heavy.Shortcuts       as Logcut (debug, info,
                                                             reportError,
                                                             warning)
import           System.Log.Heavy.Types           (LoggingSettings (..))

import           Text.Show                        (Show, show)

-- | Bigger buffer size than default
stdoutSettings :: LogBackendSettings FastLoggerBackend
stdoutSettings = FastLoggerSettings defaultLogFormat (FL.LogStdout 500000)

-- | Run the logger with default settings
run :: (MonadBaseControl IO m, MonadIO m) => LoggingT m a -> m a
run = withLoggingT $ LoggingSettings stdoutSettings

-- | Throw away the logs.
--   While running tests we often don't care about log output.
discard :: (MonadBaseControl IO m, MonadIO m) => LoggingT m a -> m a
discard = withLoggingT $ LoggingSettings NullLogSettings

source :: Text.Text
source = "Log"

showT :: Show a => a -> Text.Text
showT v = Text.pack $ show v

dump ::
     forall m a. (MonadIO m, HasLogging m, Show a)
  => a
  -> m ()
dump d = debug0 $ showT d

-- | Log func with a variable
type VarLog
   = forall m a. (MonadIO m, HasLogging m, Show a) =>
                   Text.Text -> a -> m ()

-- | Log func that just accepts text
type SimpleLog
   = forall m. (MonadIO m, HasLogging m) =>
                 Text.Text -> m ()

info :: VarLog
info d b = info0 $ d <> showT b

info0 :: SimpleLog
info0 = monkeyPatch Logcut.info

debug :: VarLog
debug d b = debug0 $ d <> showT b

debug0 :: SimpleLog
debug0 = monkeyPatch Logcut.debug

warn :: VarLog
warn d b = warn0 $ d <> showT b

warn0 :: SimpleLog
warn0 = monkeyPatch Logcut.warning

error :: VarLog
error d b = error0 $ d <> showT b

error0 :: SimpleLog
error0 = monkeyPatch Logcut.reportError

-- | Heavy logger will eat { and }, we replace them with < and >
monkeyPatch ::
  (Lazy.Text -> Single Text.Text -> m ())
  -> Text.Text
  -> m ()
monkeyPatch func d = func (Lazy.fromStrict (Text.map format d)) (Single source)

-- | heavy logger doesn't like '{'
format :: Char -> Char
format '{' = '<'
format '}' = '>'
format x   = x


lift :: MonadIO m => LoggingT IO a -> LoggingT m a
lift ioM =
  liftWith $ \runner -> liftIO $ runner $ ioM
