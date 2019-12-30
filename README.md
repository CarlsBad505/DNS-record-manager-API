# DNS Record Manager API
This application mimics how one would manager a domain's zones and records via a RESTful API. In order to use the API, you are required to acquire an API key via a POST route by submitting your email address. Your API token is hashed to the database via `bcrypt`.

## Installation Instructions
* Rails 6
* Ruby 2.6.5
* NPM + Node + Yarn (required for Webpack)

1. `bundle install`
2. `rails db:create db:migrate`
3. `rails s`

## Test Coverage
There are rspecs for routing and requests for every single API route. To run the rspecs, simply type the command `rspec -fd` in your terminal to view all 44 specs.

## API Documentation

**POST** `v1/api/create_user`

Required Params:

```
{
  "email": "youremail@domain.com'
}
```

Response JSON:
```
{
  "code": 201,
  "email": "youremail@domain.com",
  "api_key": "ocdhNdzFR8OtJFZ"
}

```

---

**POST** `v1/api/create_zone`

Required Headers:
`User-Email` `<your email address>`
`API-KEY` `<your api key>`

Required Params:
```
{
  "domain_name": "yourdomain.com",
	"ip_address": "172.16.10.1"
}
```

Response JSON:
```
{
  "code": 201,
  "domain_name": "yourdomain.com",
  "records": [
      {
          "name": "@",
          "record_type": "A",
          "data": "172.16.10.1",
          "ttl": 3600
      },
      {
          "name": "www",
          "record_type": "A",
          "data": "172.16.10.1",
          "ttl": 3600
      }
  ],
  "message": "your zone was successfully created"
}
```

---

**GET** `v1/api/view_zones`

Required Headers:
`User-Email` `<your email address>`
`API-KEY` `<your api key>`

Response JSON:
```
{
    "code": 200,
    "zones": [
        {
            "domain_name": "missiontopluto.com",
            "records": [
                {
                    "name": "@",
                    "record_type": "A",
                    "data": "172.16.10.1",
                    "ttl": 3600
                },
                {
                    "name": "www",
                    "record_type": "A",
                    "data": "204.120.0.15",
                    "ttl": 3600
                },
                {
                    "name": "*",
                    "record_type": "A",
                    "data": "204.120.0.15",
                    "ttl": 3600
                },
                {
                    "name": "volunteers.missiontopluto.com",
                    "record_type": "CNAME",
                    "data": "volunteers.missiontopluto.com",
                    "ttl": 3600
                }
            ]
        },
        {
            "domain_name": "missiontojupiter.com",
            "records": [
                {
                    "name": "@",
                    "record_type": "A",
                    "data": "172.16.10.1",
                    "ttl": 3600
                },
                {
                    "name": "www",
                    "record_type": "A",
                    "data": "172.16.10.1",
                    "ttl": 3600
                }
            ]
        },
        {
            "domain_name": "missiontosaturn.com",
            "records": [
                {
                    "name": "@",
                    "record_type": "A",
                    "data": "172.16.10.1",
                    "ttl": 3600
                },
                {
                    "name": "www",
                    "record_type": "A",
                    "data": "172.16.10.1",
                    "ttl": 3600
                }
            ]
        }
    ]
}
```

---

**GET** `v1/api/view_zone/:domain_name`

Required Headers:
`User-Email` `<your email address>`
`API-KEY` `<your api key>`

Required Params:
`domain_name` <your domain name URL encoded>

Response JSON:
```
{
  "code": 200,
  "domain_name": "yourdomain.com",
  "records": [
      {
          "name": "@",
          "record_type": "A",
          "data": "172.16.10.1",
          "ttl": 3600
      },
      {
          "name": "www",
          "record_type": "A",
          "data": "172.16.10.1",
          "ttl": 3600
      }
  ]
}
```

---

**PUT** `v1/api/update_zone/:domain_name`

*you can bulk edit records with the params example below, adding, updating, and deleting records all in one single API call*

Required Headers:
`User-Email` `<your email address>`
`API-KEY` `<your api key>`

Required Params:
`domain_name` <your domain name URL encoded>
```
{
	"add_records": [
		{
			"name": "www",
			"record_type": "A",
			"data": "204.120.0.15"
		},
		{
			"name": "volunteers.missiontopluto.com",
			"record_type": "CNAME",
			"data": "volunteers.missiontopluto.com"
		}
	],
	"remove_records": [
		{
			"name": "blog.missiontopluto.com"
		}
	]
}
```

Response JSON:
```
{
  "code": 200,
  "domain_name": "missiontopluto.com",
  "records": [
      {
          "name": "@",
          "record_type": "A",
          "data": "172.16.10.1",
          "ttl": 3600
      },
      {
          "name": "www",
          "record_type": "A",
          "data": "204.120.0.15",
          "ttl": 3600
      },
      {
          "name": "*",
          "record_type": "A",
          "data": "204.120.0.15",
          "ttl": 3600
      },
      {
          "name": "blog.missiontopluto.com",
          "record_type": "CNAME",
          "data": "blog.missiontopluto.com",
          "ttl": 3600
      }
  ],
  "message": "your zone was successfully updated"
}
```

---

**DELETE** `v1/api/delete_zone/:domain_name`

Required Headers:
`User-Email` `<your email address>`
`API-KEY` `<your api key>`

Required Params:
`domain_name` <your domain name URL encoded>

Response JSON:
```
{
  "code": 200,
  "domain_name": "yourdomain.com",
  "message": "your zone was successfully deleted"
}
```
