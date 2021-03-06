!SLIDE small

# stub\_model vs. mock\_model

* implemented rpsec-mocks
* mock_model - creates a test double representing Model
* stub_model - creates an instance of Model

* common ActiveModel methods are stubbed out:
  * id, persisted?, destroyed?, etc.
  * save, update_attributes, etc.
  * => prohibits from accessing the database

[mock_model](https://www.relishapp.com/rspec/rspec-rails/docs/mocks/mock-model) |
[stub_mode](https://www.relishapp.com/rspec/rspec-rails/docs/mocks/stub-model) |
[source](https://github.com/rspec/rspec-rails/blob/master/lib/rspec/rails/mocks.rb)

.notes Next: stubbing pain

