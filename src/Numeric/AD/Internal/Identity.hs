{-# LANGUAGE GeneralizedNewtypeDeriving, FlexibleContexts, FlexibleInstances, MultiParamTypeClasses, DeriveDataTypeable, TypeFamilies #-}
{-# OPTIONS_HADDOCK hide #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  Numeric.AD.Internal.Identity
-- Copyright   :  (c) Edward Kmett 2010
-- License     :  BSD3
-- Maintainer  :  ekmett@gmail.com
-- Stability   :  experimental
-- Portability :  GHC only
--
-----------------------------------------------------------------------------
module Numeric.AD.Internal.Identity
    ( Id(..)
    , probe
    , unprobe
    , probed
    , unprobed
    ) where

-- import Control.Applicative
import Data.Data (Data)
-- import Data.Foldable (Foldable, foldMap)
import Data.Monoid
import Data.Number.Erf
import Data.Typeable (Typeable)
-- import Data.Traversable (Traversable, traverse)
import Numeric.AD.Internal.Classes
-- import Numeric.AD.Internal.Types

newtype Id a s = Id { runId :: a } deriving
    (Iso a, Eq, Ord, Show, Enum, Bounded, Num, Real, Fractional, Floating, RealFrac, RealFloat, Monoid, Data, Typeable, Erf, InvErf)

type instance Scalar (Id a s) = a

probe :: a -> Id a s
probe = Id

unprobe :: Id a s -> a
unprobe = runId

pid :: f a -> f (Id a s)
pid = iso

unpid :: f (Id a s) -> f a
unpid = osi

probed :: f a -> f (Id a s)
probed = pid

unprobed :: f (Id a s) -> f a
unprobed = unpid

{-
instance Functor Id where
    fmap f (Id a) = Id (f a)

instance Foldable Id where
    foldMap f (Id a) = f a

instance Traversable Id where
    traverse f (Id a) = Id <$> f a

instance Applicative Id where
    pure = Id
    Id f <*> Id a = Id (f a)

instance Monad Id where
    return = Id
    Id a >>= f = f a
-}

instance Mode (Id a) s where
    auto = Id
    Id a ^* b = Id (a * b)
    a *^ Id b = Id (a * b)
    Id a <+> Id b = Id (a + b)
    Id a <**> Id b = Id (a ** b)

instance Primal (Id a s) where
    primal (Id a) = a

-- instance Erf a => Erf (Id a) where
--   erf = Id . erf . runId
--   erfc = Id . erfc . runId
--   normcdf = Id . normcdf . runId

-- instance InvErf a => InvErf (Id a) where
--   inverf = Id . inverf . runId
--   inverfc = Id . inverfc . runId
--   invnormcdf = Id . invnormcdf . runId
