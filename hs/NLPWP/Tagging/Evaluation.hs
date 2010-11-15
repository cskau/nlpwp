module NLPWP.Tagging.Evaluation (
                                 backoffTagger,
                                 baselineTagger,
                                 evalTagger
                                 ) where

import qualified Data.List as L
import NLPWP.Tagging

backoffTagger :: (Token -> Maybe Tag) -> Tag -> Token -> Maybe Tag
backoffTagger f bt t = let pick = f t in
                       case pick of
                         Just tag -> Just tag
                         Nothing  -> Just bt

baselineTagger :: Tag -> Token -> Maybe Tag
baselineTagger tag _ = Just tag

evalTagger :: (Token -> Maybe Tag) -> [TrainingInstance] -> (Int, Int, Int)
evalTagger tagFun = L.foldl' eval (0, 0, 0)
    where
      eval (n, c, u) (TrainingInstance token correctTag) =
          case tagFun token of
            Just tag -> if tag == correctTag then
                             (n+1, c+1, u)
                         else
                             (n+1, c, u)
            Nothing  -> (n+1, c, u+1)
