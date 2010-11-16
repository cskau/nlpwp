module NLPWP.Tagging.Frequency (
                                freqTagWord,
                                trainFreqTagger
                               ) where

import qualified Data.List as L
import qualified Data.Map as M
import NLPWP.Tagging

tokenTagFreqs :: [TrainingInstance] -> M.Map Token (M.Map Tag Int)
tokenTagFreqs = L.foldl' countWord M.empty
    where
      countWord m (TrainingInstance token tag) = 
          M.insertWith' (countTag tag) token (M.singleton tag 1) m
      countTag tag _ old = M.insertWith'
          (\newFreq oldFreq -> oldFreq + newFreq) tag 1 old

tokenMostFreqTag :: M.Map Token (M.Map Tag Int) -> M.Map Token Tag
tokenMostFreqTag = M.map mostFreqTag
    where
      mostFreqTag = fst . M.foldlWithKey maxTag ("NIL", 0)
      maxTag acc@(maxTag, maxFreq) tag freq
                 | freq > maxFreq = (tag, freq)
                 | otherwise = acc

trainFreqTagger :: [TrainingInstance] -> M.Map Token Tag
trainFreqTagger = tokenMostFreqTag . tokenTagFreqs

freqTagWord :: M.Map Token Tag -> Token -> Maybe Tag
freqTagWord m t = M.lookup t m

