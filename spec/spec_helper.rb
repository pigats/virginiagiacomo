require 'rspec'    

def db(collection_name) 
  @db_connection = double('db connection')
  @collection = double('collection')
  
  expect(@db_connection)
    .to receive(:collection).with(collection_name)
    .and_return(@collection)
  
end