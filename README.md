# PipedriveClient

## Installation

Add this line to your application's Gemfile:

```ruby
require 'pipedrive_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pipedrive_client

## Usage

In order to use gem, you have to create file _config/pipedrive_key.yml_ 
with your pipedrive API private key
```yaml
:api_key: "top_secret_api_key"
```

```ruby
Pipedrive::Client.new('dealFields').get

Pipedrive::Client.new(
  'products',
  id: 2,
  method: 'deals',
  query: {
    status: 'all_not_deleted'
  }
).get

```

### Optional parameters:


```ruby
{
    id: # Fetches specified id from API
    method: # Sends specified method to API 
    query: {}, # Query which will be send to api
}
```