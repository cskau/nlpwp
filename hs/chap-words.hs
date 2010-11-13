import qualified Data.Map

lookupOrder0 :: Data.Map.Map String Integer ->
                Data.Map.Map Integer [Integer] ->
                String -> Maybe [Integer]
lookupOrder0 customers orders customer =
    case Data.Map.lookup customer customers of
      Nothing -> Nothing
      Just customerId -> Data.Map.lookup customerId orders

lookupOrder1 :: Data.Map.Map String Integer ->
                Data.Map.Map Integer [Integer] ->
                String -> Maybe [Integer]
lookupOrder1 customers orders customer =
    Data.Map.lookup customer customers >>= (\m -> Data.Map.lookup m orders)

maybeBool :: Bool -> Maybe Bool
maybeBool = return

lookupOrder2 :: Data.Map.Map String Integer ->
                Data.Map.Map Integer [Integer] ->
                String -> Maybe [Integer]
lookupOrder2 customers orders customer = do
    customerId <- Data.Map.lookup customer customers
    orders     <- Data.Map.lookup customerId orders
    return orders

lookupOrder :: Data.Map.Map String Integer ->
               Data.Map.Map Integer [Integer] ->
               String -> Maybe [Integer]
lookupOrder customers orders customer = do
    customerId <- Data.Map.lookup customer customers
    Data.Map.lookup customerId orders

