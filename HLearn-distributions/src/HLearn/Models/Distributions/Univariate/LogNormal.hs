{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE FunctionalDependencies #-}

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

-- | LogNormal

module HLearn.Models.Distributions.Univariate.LogNormal
    ( LogNormal
    )
    where

import HLearn.Algebra
import HLearn.Models.Distributions.Common
import HLearn.Models.Distributions.Univariate.Normal
import HLearn.Models.Distributions.Visualization.Gnuplot

-------------------------------------------------------------------------------
-- data types

newtype LogNormal prob = LogNormal (Moments prob)
    deriving (Read,Show,Eq,Ord,Monoid,Group)
    
-------------------------------------------------------------------------------
-- training

instance (Floating prob) => HomTrainer (LogNormal prob) where
    type Datapoint (LogNormal prob) = prob
    train1dp dp = LogNormal $ train1dp $ dp

-------------------------------------------------------------------------------
-- distribution

instance Probabilistic (LogNormal prob) where
    type Probability (LogNormal prob) = prob

instance (Floating prob) => PDF (LogNormal prob) where
    pdf (LogNormal dist) dp = (1 / (dp * (sqrt $ sigma2 * 2 * pi)))*(exp $ (-1)*((log dp)-mu)^2/(2*sigma2))
        where
--             sigma2 = variance dist
--             mu = mean dist
            
            raw1 = m1

instance (Floating prob) => Mean (LogNormal prob) where
    mean (LogNormal dist) = exp $ (mean dist)+(variance dist)/2

instance (Floating prob) => Variance (LogNormal prob) where
    variance (LogNormal dist) = ((exp $ variance dist) -1)*(exp $ 2*(mean dist)+(variance dist))

instance 
    ( Floating prob
    , Enum prob
    , Show prob
    , Ord prob
    ) => PlottableDistribution (LogNormal prob) where
    
    plotType _ = Continuous

    samplePoints dist = samplesFromMinMax min max
        where
            min = (mean dist)-5*(sqrt $ variance dist)
            max = (mean dist)+5*(sqrt $ variance dist)
